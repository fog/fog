require File.join(File.dirname(__FILE__), 'fog', 'core')

module Fog
end

# FIXME: these should go away (force usage of Fog::[Compute, CDN, DNS, Storage]  etc)
require 'fog/providers'
require 'fog/terremark'

require 'fog/compute'
require 'fog/identity'
require 'fog/image'
require 'fog/volume'
require 'fog/cdn'
require 'fog/dns'
require 'fog/network'
require 'fog/storage'
