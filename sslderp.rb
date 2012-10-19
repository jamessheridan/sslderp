#!/usr/bin/env ruby

require 'net/https'
require 'date'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: sslderp -t <hostname> [OPTIONS]"
    options[:verbose] = false

    opt.on("-v", "--verbose", "Be verbose") do
        options[:verbose] = true
    end
    
    opt.on("-t", "--target HOSTNAME", "Target SSL domain to check") do |target|
        options[:target] = target
    end
    opt.on("-n", "--nagios", "Produce nagios compatible output") do
        options[:nagios] = true
    end

    opt.on("-h", "--help", "Some useful help, derps.") do
        puts opt
        exit
    end
end

opt_parser.parse!

if options[:target]
   uri = URI.parse("https://#{options[:target]}")
    
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
else
    puts opt
end
