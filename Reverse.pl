#!/usr/local/bin/perl

$filename = $ARGV[0];
$revIP = (split /.csv/, $ARGV[0])[0];

open (Krak , $filename) or die "Couldn't open file";
open (Vim, ">$revIP");

@Krakcontent = <Krak>;
chomp(@Krakcontent);
$size = @Krakcontent;

for ($a=0;$a<$size;$a=$a+1) {
        my ($name, $type, $data) = (split /,/, $Krakcontent[$a])[0, 1, 2];
        $name =~ tr/"//d;
        if ($name =~ /Name/) {
                next;
        }
        $name = $name.".".$revIP.".";
        $type =~ tr/"//d;
        $data =~ tr/"//d;
        if ($type =~ /SOA/) {
                my ($host, $email, $one, $two, $three, $four, $five) = (split / /, $data)[0, 1, 2, 3, 4, 5, 6];
                print Vim "\n$revIP. IN SOA (\n$host\n$email\n$one\n$two\n$three\n$four\n$five\n)\n\n";
                next;
        }
        if ($type =~ /NS/) {
                print Vim "NS   $data\n";
                next;
        }
        $type =~ s/PTR Record/PTR/;
        $type =~ s/Host/A/;
        $type =~ s/A Record/A/;
        $type =~ s/CNAME Record/CNAME/;
        $data =~ s/pl.ibm.com/pl.ibm.com./;

        printf Vim ("%-30s %-10s %-10s\n", $name, $type, $data);   
}


close (Krak);
close (Vim);