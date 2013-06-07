require 'fog/core'

module Fog
  module Openvz
    extend Fog::Provider
    service(:compute, 'openvz/compute', 'Compute')
  end
end

