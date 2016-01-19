require 'fog/core'
require 'fog/json'

module Fog
  module DigitalOcean
    extend Fog::Provider
    service(:compute_v2, 'Compute')
  end
end
