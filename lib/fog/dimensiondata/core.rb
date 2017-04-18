require 'fog/core'
require 'fog/json'

module Fog
  module DimensionData
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
