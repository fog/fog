module Fog

  def self.providers
    @providers ||= []
  end

end

require 'fog/aws/aws'
require 'fog/bluebox/bluebox'
require 'fog/brightbox/brightbox'
require 'fog/dnsimple/dnsimple'
require 'fog/dnsmadeeasy/dnsmadeeasy'
require 'fog/dynect/dynect'
require 'fog/ecloud/ecloud'
require 'fog/go_grid/go_grid'
require 'fog/google/google'
require 'fog/linode/linode'
require 'fog/local/local'
require 'fog/new_servers/new_servers'
require 'fog/ninefold/ninefold'
require 'fog/rackspace/rackspace'
require 'fog/slicehost/slicehost'
require 'fog/storm_on_demand/storm_on_demand'
require 'fog/vcloud/vcloud'
require 'fog/virtual_box/virtual_box'
require 'fog/voxel/voxel'
require 'fog/zerigo/zerigo'
