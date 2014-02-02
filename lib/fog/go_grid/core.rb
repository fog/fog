require 'fog/core'

module Fog
  module GoGrid

    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
