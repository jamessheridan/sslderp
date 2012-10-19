#!/usr/bin/env ruby

require 'net/https'
require 'date'

unless ARGV.length > 0
    puts "No target specified. DERP."
    puts "Usage: sslderp <hostname>"
    exit
end


uri = URI.parse("https://#{ARGV}")
http = Net::HTTP::new(uri.host,uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
http.start do |h|
  @cert = h.peer_cert
end

today = Date.today

expiry = Date.parse("#{@cert.not_after}")
days = expiry - today
puts days
