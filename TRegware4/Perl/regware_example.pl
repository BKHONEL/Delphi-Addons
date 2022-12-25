#!/usr/bin/perl
#
# regware_example.pl  --  Version 4.00
#
# Demonstration for regware4gen.pl
# TRegware 4.00 Component for Delphi
# © 2003 - WAK Productions
# Programmed by Winston Kotzan
#
# See regware4gen.pl for more detailed documentation.  This is only a demo
# for the Perl script and does not need to be installed on your server.
#


require 'regware4gen.pl'; # You need this line to use the regware module
use Getopt::Std;


use vars qw($opt_s);

  if (! getopts('s:')) {
    die "Error, use syntax: reg_test.pl -s LicenseID\n";
  }

  # The seed values passed to the constructor are from Demo #2, change them to
  # the seed values of your own program.
  $regobj = new Regware(82229366, 148131088, 141461335);

  # These are the default values in reg400_opts.pas.  Change them to whatever
  # you changed them to in reg400_opts.pas.  See that file for more details.
  $regobj->SetStorageValues(54D1, 9C41, A460, 45B7);

  $regobj->SetRegCodeSize(20);  # Set the size to 20 characters

  # Generate the registration code
  my($RegCode) = $regobj->GenerateCode($opt_s, 15);

#  $RegCode = calculate_regcode($opt_s, 1234567);
#  print "$opt_s\n";
  print "RegCode = $RegCode\n";

