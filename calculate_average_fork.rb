require 'parallel'

FILE = 'measurements.txt'.freeze
NEW_LINE = "\n".freeze
SEP = ';'.freeze

size = File.size(FILE)
cpu_count = (ARGV.first || 8).to_i

res = Parallel.map(0...cpu_count, in_processes: cpu_count) do |i|
# res = (0...cpu_count).map do |i|
  stations = {}

  File.open(FILE, mode: 'rb') do |f|
    first = size / cpu_count * i
    last = i == cpu_count - 1 ? size : size / cpu_count * (i + 1) - 1
    new_line = i != 0 && f.seek(first - 1) && f.getc == NEW_LINE

    f.seek(first)
    first += f.gets.bytesize if i != 0 && !new_line # skip first incomplete line if we are in the middle

    while (first <= last) && line = f.gets
      first += line.bytesize

      location, temperature = line.split(SEP)
      temperature = temperature.to_f

      if (loc = stations[location])
        loc[0] = temperature if temperature < loc[0]
        loc[1] = temperature if temperature > loc[1]
        loc[2] += temperature
        loc[3] += 1
      else
        stations[location] = [temperature, temperature, temperature, 1] # min, max, sum, count
      end
    end
  end

  stations
end

puts res.map { |stations| stations.map { |k, v| v.last }.sum }.sum # Just output number of processed lines
# We should merge the results from the ractors here, this part is not finished
