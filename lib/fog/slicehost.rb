require 'fog/core'

module Fog
  module Slicehost

    extend Fog::Provider

    service(:compute, 'slicehost/compute')
    service(:dns,     'slicehost/dns')

  end
end
