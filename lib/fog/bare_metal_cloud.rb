require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module BareMetalCloud

    extend Fog::Provider

    service(:compute, 'bare_metal_cloud/compute', 'Compute')

  end
end
