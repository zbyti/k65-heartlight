#!/usr/bin/perl

# 0 — nowe położenie to położenie,
# 1 — nowe położenie jest wyliczane przez dodanie położenia do bieżącej pozycji w pliku,
# 2 — jak 1, ale punktem odniesienia jest koniec pliku (położenie ma zwykle wartość ujemną).
# seek FILEHANDLE, 12, 0;

# Funkcja tell zwraca bieżące położenie w pliku:
# print tell FILEHANDLE;

# open my $levels, '<', $ARGV[0] or die "$ARGV[0]: $!\n";
open my $levels, '<', 'levels/all.txt' or die "$!\n";
open my $data, '>', 'levels/lv_packed.bin' or die "$!\n";

# header - number of levels
print $data chr(0);

# while ( my $line = <$levels> ) {
#   print $line;
# }
# print "\n";
# seek $levels, 0, 0;

# --------------------------------------------|
# %     .  @  $  *  !  #  &                   |
# 37 32 46 64 36 42 33 35 38                  |
# --------------------------------------------|
#   empty       0x00,0x00,0x00,0x00 |  0 | 1  |
# % strong wall 0x1E,0x1F,0x3E,0x3F | 30 | 2  |
# # weak wall   0x0A,0x0B,0x2A,0x2B | 10 | 3  |
# @ stone       0x0C,0x0D,0x2C,0x2D | 12 | 4  |
# $ heart       0x10,0x11,0x30,0x31 | 16 | 5  |
# * hero        0x18,0x19,0x38,0x39 | 24 | 6  |
# ! exit        0x1C,0x1D,0x3C,0x3D | 28 | 7  |
# & bomb        0x12,0x13,0x32,0x33 | 18 | 8  |
# . grass       0x0E,0x0F,0x2E,0x2F | 14 | 9  |
# --------------------------------------------|

*EMPTY       = \32;
*STRONG_WALL = \37;
*WEAK_WALL   = \35;
*STONE       = \64;
*HEART       = \36;
*HERO        = \42;
*EXIT        = \33;
*BOMB        = \38;
*GRASS       = \46;

my $odd = 1, $tile, $d_tile;

while ( my $char = getc $levels ) {
  # print ord($char);
  $tile = 0;
     if ( ord($char) == $EMPTY       ) { $tile = 1 }
  elsif ( ord($char) == $STRONG_WALL ) { $tile = 2 }
  elsif ( ord($char) == $WEAK_WALL   ) { $tile = 3 }
  elsif ( ord($char) == $STONE       ) { $tile = 4 }
  elsif ( ord($char) == $HEART       ) { $tile = 5 }
  elsif ( ord($char) == $HERO        ) { $tile = 6 }
  elsif ( ord($char) == $EXIT        ) { $tile = 7 }
  elsif ( ord($char) == $BOMB        ) { $tile = 8 }
  elsif ( ord($char) == $GRASS       ) { $tile = 9 }

  if ( $tile ) {
    if ( $odd ) {
      $odd--; $d_tile = $tile * 16;
    } else {
      $odd++; $d_tile += $tile;
      print $data chr($d_tile);
    }
  }
}

close $levels or die "$!\n";

my $lv = ((tell $data)-1)/120;
print "$lv levels parsed & packed\n";

seek $data, 0, 0; print $data chr($lv);

close $data or die "$!\n";
