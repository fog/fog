require 'fog/core'

module Fog
  module StormOnDemand

    extend Fog::Provider

    service(:compute, 'compute/storm_on_demand')

  end
end

