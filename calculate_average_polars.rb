require 'polars'

FILE = 'measurements.txt'.freeze

strings = Polars.scan_csv(FILE, sep: ';', has_header: false)
  .groupby('column_1')
  .agg([
    Polars.col('column_2').min.alias('min'),
    Polars.col('column_2').mean.alias('mean'),
    Polars.col('column_2').max.alias('max')
  ])
  .sort('column_1')
  .collect(allow_streaming: true)
  .iter_rows
  .map do |station, min, mean, max|
    "#{station}=#{min}/#{mean}/#{max}"
  end

puts "{#{strings.join(', ')}}"
