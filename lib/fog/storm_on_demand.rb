require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module StormOnDemand

    extend Fog::Provider

    service(:compute, 'storm_on_demand/compute')

  end
end

