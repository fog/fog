require 'fog/core'

module Fog
  module OpenNebula 

    extend Fog::Provider

    service(:compute, 'opennebula/compute', 'Compute')

  end
end
