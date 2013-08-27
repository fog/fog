#!/usr/local/bin/ruby

# TO FIX: it reduces the number of requests but it make the tests to faile
require 'yaml'
PATH = ARGV.shift
vcr_cassete = YAML.load_file(PATH)

@num_request = 0
@pending_requests = {}

reduced_requests = vcr_cassete["http_interactions"].reject do |i| 
  @num_request += 1
  if i["response"]["body"]["string"] =~ /running/ && i["response"]["headers"]["Content-Type"].to_s == 'application/vnd.vmware.vcloud.task+xml;version=1.5'
    @pending_requests[@num_request]=true  
    @pending_requests[@num_request] && @pending_requests[@num_request-1] && @pending_requests[@num_request-2]
  else
    @pending_requests[@num_request]=false
  end
end

cleaned = vcr_cassete["http_interactions"].size - reduced_requests.size
puts "cleaned: #{cleaned} requests"

vcr_cassete["http_interactions"] = reduced_requests

File.open(PATH, 'w') {|f| f.write(vcr_cassete.to_yaml) }

