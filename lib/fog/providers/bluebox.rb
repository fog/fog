require 'fog/core'

module Fog
  module Bluebox

    extend Fog::Provider

    service(:compute, 'compute/bluebox')

  end
end
