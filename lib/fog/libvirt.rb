require 'fog/core'

module Fog
  module Libvirt

    extend Fog::Provider

    service(:compute, 'libvirt/compute', 'Compute')

  end
end
