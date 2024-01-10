#! /usr/bin/env ruby

require_relative './stations/stations'

MEASUREMENTS_FILE_NAME = 'measurements.txt'

iterations = ARGV.first.to_i

File.open(MEASUREMENTS_FILE_NAME, 'w') do |measurements_file|
  stations_size = Stations.ary.size
  i = 0
  while i < iterations do
    i += 1
    station = Stations.ary.sample
    measurements_file.puts(station.to_file_str)
  end
end
