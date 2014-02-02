require 'fog/core'

module Fog
  module GoGrid

    extend Fog::Provider

    service(:compute, 'go_grid/compute', 'Compute')

  end
end
