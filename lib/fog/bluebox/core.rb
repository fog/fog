require 'fog/core'

module Fog
  module Bluebox

    extend Fog::Provider

    service(:blb,     'BLB')
    service(:compute, 'Compute')
    service(:dns,     'DNS')

  end
end
