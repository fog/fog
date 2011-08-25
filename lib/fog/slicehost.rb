require 'fog/core'

module Fog
  module Slicehost

    extend Fog::Provider

    service(:compute, 'compute/slicehost')
    service(:dns,     'slicehost/slicehost')

  end
end
