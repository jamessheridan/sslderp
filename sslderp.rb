#!/usr/bin/env ruby

require 'net/https'
require 'date'
require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
    opt.banner = "Usage: sslderp -t <hostname> [OPTIONS]"
    options[:verbose] = false
    options[:nagios] = false

    opt.on("-v", "--verbose", "Be verbose") do
        options[:verbose] = true
    end
    
    opt.on("-t", "--target HOSTNAME/IP[:PORT]", "Target SSL domain to check") do |target|
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

begin
    opt_parser.parse!
    mandatory = [:target]
    missing = mandatory.select{ |param| options[param].nil? }
    if not missing.empty?
        puts "Specifying a target is mandatory."
        puts opt_parser
        exit
    end

    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $!.to_s
        puts opt_parser
        exit 3

end

begin
    uri = URI.parse("https://#{options[:target]}")
    
    http = Net::HTTP::new(uri.host,uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.start do |h|
        @cert = h.peer_cert
    end

    rescue
        puts $!.to_s
        exit 3

end

today = Date.today
expiry = Date.parse("#{@cert.not_after}")
days = expiry - today
days = days.truncate

if options[:nagios] == true
    if days < 30
        if days <15
            puts days
            exit 2
        end
        puts days
        exit 1
    else
        puts days
        exit 0
    end

else
    puts days
end

