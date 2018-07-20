#!/usr/local/bin/perl

open (COMMAND, '/home/haroon/IBMi/Command_list') or die "Couldn't open file";
open (PLAYBOOK, '>Playbook.yaml');

@names = <COMMAND>;
# The file is converted to an array, where each line of the Command_list file becomes an element of the names array
chomp(@names);

$size = @names;

$template = "- hosts: all
  remote_user: ansible
  serial: 0
  gather_facts: false

  tasks:
";

$raw = "
    - name: \"ineedchanging\"
      raw: system \"replaceme\"
      ignore_errors: yes   
";

print PLAYBOOK $template;

for ($a=0;$a<$size;$a=$a+1) {
    $b = $a + 1;
    $rawtotal = $rawtotal.$raw;
    $rawtotal =~ s/replaceme/$names[$a]/;
    $rawtotal =~ s/ineedchanging/$b/;
};
# $rawtotal becomes a string consisting of every raw module required for the playbook
# The commands in the Command_list file become raw commands in the Playbook

print PLAYBOOK $rawtotal;

close (COMMAND);
close (PLAYBOOK);