require 'fog/core'

module Fog
  module Bluebox

    extend Fog::Provider

    service(:blb,     'bluebox/blb',      'BLB')
    service(:compute, 'bluebox/compute',  'Compute')
    service(:dns,     'bluebox/dns',      'DNS')

  end
end
