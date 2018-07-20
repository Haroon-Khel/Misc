#!/usr/local/bin/perl

$filename = $ARGV[0];
$textname = (split /.csv/, $filename)[0];

open (Krak , $filename) or die "Couldn't open file";
open (Vim, ">$textname");

@Krakcontent = <Krak>;
chomp(@Krakcontent);
$size = @Krakcontent;

for ($a=0;$a<$size;$a=$a+1) {
    my ($name, $type, $data) = (split /,/, $Krakcontent[$a])[0, 1, 2];
        $name =~ tr/"//d;
        $data =~ tr/"//d;
        if ($name =~ /Name/) {
                next;
        }
        $type =~ tr/"//d;
        if ($type =~ /SOA/) {
                my ($host, $email, $one, $two, $three, $four, $five) = (split / /, $data)[0, 1, 2, 3, 4, 5, 6];
                print Vim "\n$textname. IN SOA (\n$host\n$email\n$one\n$two\n$three\n$four\n$five\n)\n\n";
                next;
        }
        if ($type =~ /NS/) {
                print Vim "NS   $data\n";
                next;
        }
        $type =~ s/Host/A/;
        $type =~ s/CNAME Record/CNAME/;
        $type =~ s/A Record/A/;
        $data =~ s/pl.ibm.com/pl.ibm.com./;

        printf Vim ("%-20s %-10s %-10s\n", $name, $type, $data);   
}

close (Krak);
close (Vim);