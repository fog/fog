require 'fog/core'

module Fog
  module Bluebox

    extend Fog::Provider

    service(:compute, 'compute/bluebox')
    service(:dns,     'bluebox/dns')

  end
end
