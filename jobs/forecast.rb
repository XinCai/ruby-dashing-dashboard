require 'net/https'
require 'json'

# Forecast API Key from https://developer.forecast.io
forecast_api_key = "4d7dd323573e325fbead322ac4e5dd57"

# Latitude, Longitude for location
forecast_location_lat = "33.820261681425805"
forecast_location_long = "151.09581658479988"

# Unit Format
# "us" - U.S. Imperial
# "si" - International System of Units
# "uk" - SI w. windSpeed in mph
forecast_units = "si"
  
SCHEDULER.every '5s', :first_in => 0 do |job|
  http = Net::HTTP.new("api.forecast.io", 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  response = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"))
  forecast = JSON.parse(response.body)  
  forecast_current_temp = forecast["currently"]["temperature"].round
  forecast_hour_summary = forecast["hourly"]["summary"]
  timezone = forecast["timezone"]
  send_event('forecast', { temperature: "#{forecast_current_temp}", hour: "#{forecast_hour_summary}"})
  #send_event('forecast', {temperature: "#{timezone}"})
  #send_event('temperature', {temperature: forecast["currently"]["temperature"]})
  #send_event('timezone',{timezone: forecast["timezone"]})
end