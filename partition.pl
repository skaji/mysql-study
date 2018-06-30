#!/usr/bin/env perl
use strict;
use warnings;
use Time::Moment;

my $start = Time::Moment->from_string('2018-01-01T00:00:00+09:00');
my $end   = Time::Moment->from_string('2039-01-01T00:00:00+09:00');

my @partition;
my $time = $start;
while ($time < $end) {
    my $next = $time->plus_weeks(1);
    my $partition = sprintf "PARTITION p%s VALUES LESS THAN (%d) ENGINE = InnoDB",
        $time->strftime("%Y_week%U"), $next->epoch;
    push @partition, $partition;
    $time = $next;
}
push @partition, "PARTITION pMAX VALUES LESS THAN MAXVALUE ENGINE = InnoDB";

print <<'___';
CREATE TABLE `test1` (
  `id`          INTEGER(10) UNSIGNED NOT NULL,
  `record_time` INTEGER(10) UNSIGNED NOT NULL,
  `value1`      INTEGER(10) UNSIGNED DEFAULT 0,
  `value2`      INTEGER(10) UNSIGNED DEFAULT 0,
  `value3`      INTEGER(10) UNSIGNED DEFAULT 0,
  PRIMARY KEY (`id`, `record_time`)
) ENGINE = INNODB
PARTITION BY RANGE COLUMNS (`record_time`) (
___

print join ",\n", map { "  $_" } @partition;

print <<"___";
);
___
