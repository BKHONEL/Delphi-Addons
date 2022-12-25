# regware4gen.pl  --  Version 4.00
#
# Perl unit to generate registration codes for
# TRegware 4.00 Component for Delphi
# © 2003 - WAK Productions
# Programmed by Winston Kotzan
#
# See regware_example.pl for an example of how to use the perl script
#


#
# This is the name of the current module.
#
package Regware;

#===============================================================================
#
# Constructor:
#    $obj = new Regware($Seed1, $Seed2, $Seed3);
#
# Methods:
#    $obj->SetSeeds($Seed1, $Seed2, $Seed3);
#    $obj->SetRegCodeSize($Size);
#    $obj->SetStorageValues($SEED_STORAGE1, $SEED_STORAGE2,
#                           $SEED_STORAGE3, $SEED_D);
#    $obj->GenerateCode($UserID, [$ExpireDays]);
#
# *p/s: For more details, please refer to the description below.
#
#===============================================================================

use strict;

#===============================================================================
#
# CONSTRUCTOR:    $obj = new Regware($Seed1, $Seed2, $Seed3);
#
# DESCRIPTION:    This is the constructor of the Regware object. The Seed values
#                 correspond to the Seed values in your TRegware program
#
#===============================================================================
sub new {
    my($class)         = shift;
    my($self)         = {};
    bless $self, $class;

    $self->{'Seed1'} = shift;
    $self->{'Seed2'} = shift;
    $self->{'Seed3'} = shift;

    #load the default values
    $self->{'SEED_STORAGE1'} = hex '54D1';
    $self->{'SEED_STORAGE2'} = hex '9C41';
    $self->{'SEED_STORAGE3'} = hex 'A460';
    $self->{'SEED_D'} = hex '45B7';
    $self->{'RegCodeSize'} = 20;

    return $self;
}

#===============================================================================
#
# METHOD:    $obj->SetRegCodeSize($Size);
#
# DESCRIPTION:  Sets the RegCodeSize value as seen in the Delphi component
#
#===============================================================================
sub SetRegCodeSize {
    my($self)      = shift;
    $self->{'RegCodeSize'} = shift;
    $self;
}

#===============================================================================
#
# METHOD:    $obj->SetSeeds($Seed1, $Seed2, $Seed3);
#
# DESCRIPTION:  Sets the seed properties of the regcode generator
#
#===============================================================================
sub SetSeeds {
    my($self)      = shift;
    $self->{'Seed1'} = shift;
    $self->{'Seed2'} = shift;
    $self->{'Seed3'} = shift;
    $self;
}

#===============================================================================
#
# METHOD:    $obj->SetStorageValues($SEED_STORAGE1, $SEED_STORAGE2,
#                                   $SEED_STORAGE3, $SEED_D);
#
# DESCRIPTION:    Hex strings of the SEED_STORAGE values in reg400_opts.pas.
#
#===============================================================================
sub SetStorageValues {
    my($self)      = shift;
    my($SEED_STORAGE1) = shift;
    my($SEED_STORAGE2) = shift;
    my($SEED_STORAGE3) = shift;
    my($SEED_D) = shift;
    $self->{'SEED_STORAGE1'} = hex $SEED_STORAGE1;
    $self->{'SEED_STORAGE2'} = hex $SEED_STORAGE2;
    $self->{'SEED_STORAGE3'} = hex $SEED_STORAGE3;
    $self->{'SEED_D'} = hex $SEED_D;
    $self;
}

#===============================================================================
#
# METHOD:    $obj->GenerateCode($UserID, [$ExpireDays]);
#
# DESCRIPTION:    Generates the registration code based on $UserID.  The code
#                 will expire in $ExpireDays. 0 for $ExpireDays means no
#                 expiration.  GenerateCode() returns the registration code
#                 for $UserID.
#
#===============================================================================
sub GenerateCode {
    my($self)       = shift;
    my($UserID)     = shift;
    my($ExpireDays) = shift;
    my($S1,$S2,$S3,$S4,$S5,$S6,$S7,$S8,$S9,$S10,$S11,$S12,$S13,$STMP); # strings
    my($V1,$V2,$V3,$I1,$I2);  # integers
    my($Month, $Day, $Year); # integers for encoding date
    my(@cleanarray) = (undef, undef, undef, undef, undef, undef);

    if ((length($UserID) > 108) || (length($UserID) < 5)) { return 0 };

    #========= Expiration Date Segment =========================================
    if ($ExpireDays != 0) {
      my(@currenttime) = localtime(time() + $ExpireDays * 24*60*60);

      $Month = $currenttime[4] + 1;
      $Day   = $currenttime[3];
      $Year  = $currenttime[5] + 1900;

      $V1 = $Month ^ $self->{SEED_D} & 0x000F;
      $V2 = $Day   ^ $self->{SEED_D} & 0x00FF;
      $V3 = $Year  ^ $self->{SEED_D} & 0x0FFF;

      $V1 = sprintf("%X", $V1);
      $V2 = sprintf("%X", $V2);
      $V3 = sprintf("%X", $V3);

      $S2 =  $V1;
      $S8  = chop $V2;
      $S10 = chop $V2;
      $S12 = chop $V3;
      $S6  = chop $V3;
      $S4  = chop $V3;
    }

    #========= Segment #1 ======================================================
    ($V1,$V2,$V3,$I1,$I2,$STMP) = @cleanarray;
    my($Seed1) = $self->{'Seed1'} ^ $self->{'SEED_STORAGE1'};

    $V3 = (length $UserID) - 1;
    $V1 = ord(substr($UserID, 0, 1)) + ord(substr($UserID, 1, 1)) +
          ord(substr($UserID, int($V3 / 2), 1)) + ord(substr($UserID, $V3, 1))+
          ord(substr($UserID, $V3 - 1, 1));
    $V2 = ($Seed1 % $V1) & 0x00FF;
    $STMP = sprintf("%02X", $V2);
    $S3 = chop $STMP;
    $S1 = chop $STMP;

    $V1 = length($UserID);
    if ($V1 > 16) { $S5 = '0' } else { $S5 = sprintf("%X", $V1) };

    #========= Segment #2 ======================================================
    ($V1,$V2,$V3,$I1,$I2,$STMP) = @cleanarray;
    my($Seed2) = $self->{'Seed2'} ^ $self->{'SEED_STORAGE2'};

    for ($I1 = 0; $I1 < (length $UserID); $I1++) {
      $V1 += ord(substr($UserID, $I1, 1));
    }
    $V1 = (($V1 << 4) ^ $Seed2) & 0x0FFF;
    $STMP = sprintf("%03X", $V1);
    $S11 = chop $STMP;
    $S9 = chop $STMP;
    $S7 = chop $STMP;

    #========= Segment #3 ======================================================
    ($V1,$V2,$V3,$I1,$I2,$STMP) = @cleanarray;
    my($Seed3) = $self->{'Seed3'} ^ $self->{'SEED_STORAGE3'};

    for ($I1 = 0; $I1 < length($UserID); $I1++) {
      $V2 = $V2 + ord(substr($UserID, $I1, 1));
    }
    $V2 = $V2 * int(0xEFFFFFF / $V2);
    $I2 = 31;
    for ($I1 = 1; $I1 <= 32; $I1++) {
      $V3 = (($Seed3 << $I1) | ($Seed3 >> $I2)) & 0xFFFFFFFF;
      $V3 = abs($V3);
      if ($V3 > $V2) {
        $V1 = $V3 % $V2
      } else {
        $V1 = $V2 % $V3;
      }
      $STMP = $STMP . sprintf("%03X", $V1 & 0xFFF);
      $I2--;
    }
    $S13 = substr($STMP, 0, $self->{'RegCodeSize'} - 12);

    "$S1$S2$S3$S4$S5$S6$S7$S8$S9$S10$S11$S12$S13";
}
#===============================================================================
#
# END of the module.
#
#===============================================================================

1;