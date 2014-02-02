require 'fog/core'

module Fog
  module BareMetalCloud

    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
