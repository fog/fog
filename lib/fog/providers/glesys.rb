require 'fog/core'

module Fog
  module Glesys

    extend Fog::Provider

    service(:compute, 'compute/glesys')

  end
end
