require 'fog/core'

module Fog
  module VirtualBox

    extend Fog::Provider

    service(:compute, 'virtual_box/compute', 'Compute')

  end
end
