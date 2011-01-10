require 'spec'
require 'open-uri'
require 'fog'
require 'fog/bin'
require 'fog/bin/vcloud'

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end
