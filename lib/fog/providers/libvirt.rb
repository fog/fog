require 'fog/core'

module Fog
  module Libvirt

    extend Fog::Provider

    service(:compute, 'compute/libvirt')

  end
end
