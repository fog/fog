module Fog

  def self.providers
    @providers ||= []
  end

end

require 'fog/providers/aws'
require 'fog/providers/bluebox'
require 'fog/providers/brightbox'
require 'fog/providers/dnsimple'
require 'fog/providers/dnsmadeeasy'
require 'fog/providers/dynect'
require 'fog/providers/ecloud'
require 'fog/providers/go_grid'
require 'fog/providers/google'
require 'fog/providers/linode'
require 'fog/providers/local'
require 'fog/providers/new_servers'
require 'fog/providers/ninefold'
require 'fog/providers/rackspace'
require 'fog/providers/slicehost'
require 'fog/providers/storm_on_demand'
require 'fog/providers/vcloud'
require 'fog/providers/virtual_box'
require 'fog/providers/voxel'
require 'fog/providers/zerigo'
