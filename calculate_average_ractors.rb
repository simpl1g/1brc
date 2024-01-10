FILE = 'measurements1.txt'.freeze
NEW_LINE = "\n".freeze
SEP = ';'.freeze

size = File.size(FILE)
cpu_count = (ARGV.first || 8).to_i

ractors = cpu_count.times.map do |i|
  Ractor.new(size, cpu_count, i) do |size, cpu_count, i|
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

    Ractor.yield(stations)
  end
end

res = ractors.map(&:take)
puts res.map { |stations| stations.map { |k, v| v.last }.sum }.sum
# We should merge the results from the ractors here, this part is not finished
