require 'fog/core'

module Fog
  module BareMetalCloud

    extend Fog::Provider

    service(:compute, 'bare_metal_cloud/compute', 'Compute')
    service(:loadbalancing, 'bare_metal_cloud/loadbalancing', 'LoadBalancing')
  end
end
