require 'net/http'
require 'json'

def holidays_url(year) 
  url = URI("https://holidays-calendar-ru.vercel.app/api/calendar/#{year}/holidays")
end 

def request(year)
  url = holidays_url(year)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = (url.scheme == 'https')
  request = Net::HTTP::Get.new(url)
  request['Content-Type'] = 'application/json'
  response = http.request(request)
  if response.code == "200"
    return JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    return nil
  end
end 


def get_holidays_for(year)
    json_data = request(year)
    File.open("chest/holidays_for_#{year}.json", 'w') do |file|
      file.write(json_data)
    end 
end 
