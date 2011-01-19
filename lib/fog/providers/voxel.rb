require 'fog/core'

module Fog
  module Voxel

    extend Fog::Provider

    service(:compute, 'compute/rackspace')
  end
end
