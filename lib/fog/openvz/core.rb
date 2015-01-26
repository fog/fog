require 'fog/core'

module Fog
  module Openvz
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end
