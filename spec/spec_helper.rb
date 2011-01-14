require 'spec'
require 'open-uri'
require 'fog'

test_value = "!!! test value !!!"

Fog.credentials[:aws_access_key_id]     = test_value
Fog.credentials[:aws_secret_access_key] = test_value

Fog.credentials[:vcloud] = { 
  :ecloud => {  :username     => test_value,
                :password     => test_value,
                :versions_uri => test_value,
                :module       => "Hash" } }

require 'fog/bin'

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end
