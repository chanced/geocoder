require 'geocoder'
require 'open-uri'
module Geocoder
  module Request

    def location
      unless defined?(@location)
        local_ip = env.has_key?('HTTP_X_REAL_IP') ? env['HTTP_X_REAL_IP'] : (env.has_key?('HTTP_X_FORWARDED_FOR') ? env['HTTP_X_FORWARDED_FOR'] : ip)
        ext_ip = (local_ip == "127.0.0.1") ? open("http://www.myexternalip.com/raw").read : local_ip
        puts ext_ip
        @location = Geocoder.search(ext_ip).first
      end
      @location
    end
  end
end

if defined?(Rack) and defined?(Rack::Request)
  Rack::Request.send :include, Geocoder::Request
end
