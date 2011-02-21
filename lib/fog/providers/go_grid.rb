require 'fog/core'

module Fog
  module GoGrid

    extend Fog::Provider

    service(:compute, 'compute/go_grid')

  end
end
