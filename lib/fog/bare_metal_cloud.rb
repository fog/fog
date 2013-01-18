require 'fog/core'

module Fog
  module BareMetalCloud

    extend Fog::Provider

    service(:compute, 'bare_metal_cloud/compute', 'Compute')

  end
end
