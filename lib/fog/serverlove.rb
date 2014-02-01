require 'fog/core'

module Fog
  module Serverlove
    extend Fog::Provider

    service(:compute, 'serverlove/compute', 'Compute')

  end
end
