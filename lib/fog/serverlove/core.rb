require 'fog/core'
require 'fog/json'

module Fog
  module Serverlove
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
