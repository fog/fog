require 'fog/core'
require 'fog/json'

module Fog
  module CloudAtCost
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end
