require 'fog/core'

module Fog
  module OpenNebula
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end
