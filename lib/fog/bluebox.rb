require 'fog/core'

module Fog
  module Bluebox

    extend Fog::Provider

    service(:compute, 'bluebox/compute',  'Compute')
    service(:dns,     'bluebox/dns',      'DNS')

  end
end
