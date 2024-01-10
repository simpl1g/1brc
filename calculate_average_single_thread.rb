FILE = 'measurements.txt'.freeze
SEP = ';'.freeze
stations = {}

File.open(FILE).each_line do |line|
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

strings = stations.map do |station, measurements|
  min = measurements[0]
  max = measurements[1]
  avg = measurements[2] / measurements[3]

  "#{station}=#{min}/#{avg}/#{max}"
end

puts "{#{strings.join(', ')}}"
