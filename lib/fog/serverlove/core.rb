require 'fog/core'

module Fog
  module Serverlove
    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
