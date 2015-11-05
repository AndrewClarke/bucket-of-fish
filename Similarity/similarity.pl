
sub smush ($) {
  my $str = lc $_[0];
  $str =~ s/'//g;

  my @result;
  foreach my $s (split /\W+/, $str) {
      next if length($s) == 0;

      if(length($s) == 1) {
          push @result, $s;
          next;
      }

      foreach my $i (0 .. length($s) - 2) {
          push @result, substr($s, $i, 2);
      }
  }

  return sort @result;
}  # smush


sub similarity ($$) {
    my ($str1, $str2) = @_;
    my @pairs1 = smush $str1;
    my @pairs2 = smush $str2;

    my $n = (my $l1 = scalar @pairs1) + (my $l2 = scalar @pairs2);
    return 1.0 if $n == 0;

    my ($i1, $i2, $k) = (0, 0, 0);
    while($i1 < $l1 && $i2 < $l2) {
        if($pairs1[$i1] lt $pairs2[$i2])
            { ++$i1 }
        elsif($pairs1[$i1] gt $pairs2[$i2])
            { ++$i2 }
        else
            { ++$i1; ++$i2; ++$k }
    }

    return (2.0 * $k) / $n;
}  # similarity

my $str1 = "  Emo sees Girl. Girl sees Emo. Girl runs away.   See Emo cry.  Cry Emo, cry.  ";
my $str2 = "  Emo sees a Girl. The Girl sees Emo. The Girl runs away from Emo.   See Emo cry.  Cry Emo, cry.  ";

print similarity($str1, $str2), "\n";

