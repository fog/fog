require 'fog/core'
require 'fog/xml'

module Fog
  module BareMetalCloud
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
