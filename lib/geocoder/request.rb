require 'geocoder'
require 'open-uri'
module Geocoder
  module Request

    def location
      unless defined?(@location)
        ip = env.has_key?('HTTP_X_REAL_IP') ? env['HTTP_X_REAL_IP'].first : (env.has_key?('HTTP_X_FORWARDED_FOR') ? env['HTTP_X_FORWARDED_FOR'].first : ip)
        if ip == "127.0.0.1"
          ip = eval(open("http://ip2country.sourceforge.net/ip2c.php?format=JSON").read)[:ip]
        end
        @location = Geocoder.search(ip).first
      end
      @location
    end
  end
end

if defined?(Rack) and defined?(Rack::Request)
  Rack::Request.send :include, Geocoder::Request
end
