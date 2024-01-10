require 'securerandom'

class WeatherStation
  attr_reader :location, :mean_temperature

  STANDARD_DEVIATION = 10

  def initialize(location, mean_temperature)
    @location = location
    @mean_temperature = mean_temperature
  end

  def to_file_str
    "#{location};#{measurement}"
  end

  # random gaussian
  def measurement
    (SecureRandom.random_number * STANDARD_DEVIATION + mean_temperature).round(1)
  end
end

# test
# puts WeatherStation.new('hola', 10.0).measurement
