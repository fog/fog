require 'fog/core'

module Fog
  module Ninefold

    extend Fog::Provider

    service(:compute, 'compute/ninefold')

  end
end
