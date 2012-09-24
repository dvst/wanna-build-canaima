#
# WannaBuild.pm: library for wanna-build and sbuild
# Copyright (C) 2005 Ryan Murray <rmurray@debian.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# $Id$
#

package WannaBuild;

use strict;
use POSIX;
use FileHandle;
use Time::Local;

require Exporter;
@WannaBuild::ISA = qw(Exporter);
@WannaBuild::EXPORT = qw(version_less version_lesseq version_eq
			version_compare binNMU_version parse_date isin);

$WannaBuild::opt_correct_version_cmp = 0;

sub version_less {
	my $v1 = shift;
	my $v2 = shift;
	
	return version_compare( $v1, "<<", $v2 );
}

sub version_lesseq {
	my $v1 = shift;
	my $v2 = shift;

	return version_compare( $v1, "<=", $v2 );
}

sub version_eq {
	my $v1 = shift;
	my $v2 = shift;

	return version_compare( $v1, "=", $v2 );
}

sub version_compare {
	my $v1 = shift;
	my $rel = shift;
	my $v2 = shift;
	
	if ($WannaBuild::opt_correct_version_cmp) {
		system "dpkg", "--compare-versions", $v1, $rel, $v2;
		return $? == 0;
	}
	else {
		if ($rel eq "=" || $rel eq "==") {
			return $v1 eq $v2;
		}
		elsif ($rel eq "<<") {
			return do_version_cmp( $v1, $v2 );
		}
		elsif ($rel eq "<=" || $rel eq "<") {
			return $v1 eq $v2 || do_version_cmp( $v1, $v2 );
		}
		elsif ($rel eq ">=" || $rel eq ">") {
			return !do_version_cmp( $v1, $v2 );
		}
		elsif ($rel eq ">>") {
			return $v1 ne $v2 && !do_version_cmp( $v1, $v2 );
		}
		else {
			warn "version_compare called with bad relation '$rel'\n";
			return $v1 eq $2;
		}
	}
}

sub do_version_cmp {
	my($versa, $versb) = @_;
	my($epocha,$upstra,$reva);
	my($epochb,$upstrb,$revb);
	my($r);

	($epocha,$upstra,$reva) = split_version($versa);
	($epochb,$upstrb,$revb) = split_version($versb);

	# compare epochs
	return 1 if $epocha < $epochb;
	return 0 if $epocha > $epochb;

	# compare upstream versions
	$r = version_cmp_single( $upstra, $upstrb );
	return $r < 0 if $r != 0;

	# compare Debian revisions
	$r = version_cmp_single( $reva, $revb );
	return $r < 0;
}

sub order {
	for ($_[0])
	{
	/\~/     and return -1;
	/\d/     and return  0;
	/[a-z]/i and return ord;
		     return (ord) + 256;
	}
}

sub version_cmp_single {
	my($versa, $versb) = @_;
	my($a,$b,$lena,$lenb,$va,$vb,$i);

	for(;;) {
		# compare non-numeric parts
		$versa =~ /^([^\d]*)(.*)/; $a = $1; $versa = $2;
		$versb =~ /^([^\d]*)(.*)/; $b = $1; $versb = $2;
		$lena = length($a);
		$lenb = length($b);
		for( $i = 0; $i < $lena || $i < $lenb; ++$i ) {
			$va = $i < $lena ? order(substr( $a, $i, 1 )) : 0;
			$vb = $i < $lenb ? order(substr( $b, $i, 1 )) : 0;
			return $va - $vb if $va != $vb;
		}
		# compare numeric parts
		$versa =~ /^(\d*)(.*)/; $a = $1; $a ||= 0; $versa = $2;
		$versb =~ /^(\d*)(.*)/; $b = $1; $b ||= 0; $versb = $2;
		return $a - $b if $a != $b;
		return 0 if !$versa && !$versb;
		if (!$versa) {
			return +1 if order(substr( $versb, 0, 1 ) ) < 0;
			return -1;
		}
		if (!$versb) {
			return -1 if order(substr( $versa, 0, 1 ) ) < 0;
			return +1;
		}
	}
}

sub split_version {
	my($vers) = @_;
	my($epoch,$revision) = (0,"");

	if ($vers =~ /^(\d+):(.*)/) {
		$epoch = $1;
		$vers = $2;
	}

	if ($vers =~ /(.*)-([^-]+)$/) {
		$revision = $2;
		$vers = $1;
	}

	return( $epoch, $vers, $revision );
}

sub binNMU_version {
	my $v = shift;
	my $binNMUver = shift;

	return "$v+b$binNMUver" if $binNMUver;
        return $v;
}


my %monname = ('jan', 0, 'feb', 1, 'mar', 2, 'apr', 3, 'may', 4, 'jun', 5,
		'jul', 6, 'aug', 7, 'sep', 8, 'oct', 9, 'nov', 10, 'dec', 11 );

sub parse_date {
	my $text = shift;

	return 0 if !$text;

	if ($text =~ /^(\d{4}) (\w{3}) (\d+) (\d{2}):(\d{2}):(\d{2})$/) {
		my ($year, $mon, $day, $hour, $min, $sec) = ($1, $2, $3, $4, $5, $6);
		$mon =~ y/A-Z/a-z/;
		die "Invalid month name $mon" if !exists $monname{$mon};
		$mon = $monname{$mon};
		return timegm($sec, $min, $hour, $day, $mon, $year);
	} elsif ($text =~ /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})(?:\.\d+)?$/) {
		my ($year, $mon, $day, $hour, $min, $sec) = ($1, $2-1, $3, $4, $5, $6);
		return timegm($sec, $min, $hour, $day, $mon, $year);
	} else {
		die "Cannot parse date: $text\n";
	}
}

sub isin {
	my $val = shift;

	return 0 if !$val;

	return grep( $_ eq $val, @_ );
}

#sub get_distributions {
#	my %distributions;

#	my $q = 'SELECT distribution, public, auto_dep_wait FROM distributions';
#	my $rows = $dbh->selectall_hashref($q, 'distribution');
#	foreach my $name (keys %$rows) {
#		$distributions{$name} = {};
#		$distributions{$name}->{'noadw'} = 1 if ($rows->{$name}->{'auto_dep_wait'});
#		$distributions{$name}->{'hidden'} = 1 if ($rows->{$name}->{'public'});
#	}

#	return %distributions;
#}

1;
__END__

=head1 NAME

WannaBuild - Database meant to control automated builds packages 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 version_less

g

=head2 version_lesseq

g

=head2 version_eq

g

=head2 version_compare

3 argumentos recibidos: version1, relacion(comparador) y version2.
En caso que opt_correct_version_cmp al ser evaluado devuelva verdadero (hasta ahora no he visto en todo el ciclo de vida una asignacion de valor verdadero a esta variable), realiza llamado a comando de sistema "dpkg --compare-versions $v1 $rel $v2" y devuelve verdadero si el estatus es OK (0).

=head2 do_version_cmp

g

=head2 order

g

=head2 version_cmp_single

g

=head2 split_version

g

=head2 binNMU_version

g

=head2 parse_date

g

=head2 isin

g

=head2 get_distributions

COMMENTED - 

