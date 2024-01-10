# The One Billion Row Challenge - Ruby Edition

Ruby edition of the [1BRC](https://github.com/gunnarmorling/1brc/tree/main) Java challenge.

# Tools

### Gemfile

I included a profiler so you can tweak your implementation and create the fastest one!
`polars` and `parallel` gems included to compare different approaches

```bash
bundle install
```

### Generating measurements.txt
```bash
/usr/bin/time -h -l -p ruby --yjit ./create_measurements.rb 10_000_000 # 10mln rows for tests, 1bln for real comparison

bundle exec ruby-prof create_measurements.rb -- 1000 # with profiler
```

### Calculating data

The main script. This is where the solution goes!

Results for 10mln rows file on my M1 Max
```shell
## Single thread
/usr/bin/time -h -l -p ruby --yjit calculate_average_single_thread.rb
# 10mln
real 3.39
user 3.31
sys 0.04
14155776  maximum resident set size

# 1bln
real 331.03
user 326.21
sys 3.50
15007744  maximum resident set size

## Polars
/usr/bin/time -h -l -p ruby --yjit calculate_average_polars.rb
# 10mln
real 0.27
user 0.96
sys 0.08
212811776  maximum resident set size

# 1bln
real 13.58
user 89.00
sys 3.59
14016413696  maximum resident set size # 14Gb RSS

## Ractors
# 10mln
/usr/bin/time -h -l -p ruby --yjit calculate_average_ractors.rb 8 # 8 cores
real 4.94
user 16.38
sys 1.99
16400384  maximum resident set size

/usr/bin/time -h -l -p ruby --yjit calculate_average_ractors.rb 4 # 4 cores
real 2.99
user 7.91
sys 0.45
15450112  maximum resident set size

# 1bln
/usr/bin/time -h -l -p ruby --yjit calculate_average_ractors.rb 4
real 281.13
user 758.73
sys 42.77
15155200  maximum resident set size

## Fork
# 10mln
/usr/bin/time -h -l -p ruby --yjit calculate_average_fork.rb 8
real 0.78
user 5.39
sys 0.09
17547264  maximum resident set size


/usr/bin/time -h -l -p ruby --yjit calculate_average_fork.rb 4
real 1.42
user 5.28
sys 0.07
16646144  maximum resident set size

# 1bln
/usr/bin/time -h -l -p ruby --yjit calculate_average_fork.rb 8
real 67.83
user 517.13
sys 5.49
17793024  maximum resident set size
```
