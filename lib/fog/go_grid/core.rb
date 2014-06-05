require 'fog/core'
require 'fog/json'

module Fog
  module GoGrid
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
