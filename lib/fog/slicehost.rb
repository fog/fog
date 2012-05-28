require 'fog/core'

module Fog
  module Slicehost

    extend Fog::Provider

    service(:compute, 'slicehost/compute',  'Compute')
    service(:dns,     'slicehost/dns',      'DNS')

  end
end
