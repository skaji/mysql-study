#!/usr/bin/env perl
use strict;
use warnings;
use Time::Moment;

my $start = Time::Moment->from_string('2018-01-01T00:00:00+09:00');
my $end   = Time::Moment->from_string('2025-12-31T00:00:00+09:00');

my @id = 1..1000;

my $time = $start;
while ($time <= $end) {
    my $epoch = $time->epoch;
    my $rand = int rand scalar @id;
    my @id = @id[ map { ($rand + $_) % @id } 1..10 ];
    for my $id (@id) {
        print "$id,$epoch,$rand,$rand,$rand\n";
    }
    $time = $time->plus_minutes(5);
}
