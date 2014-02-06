require 'fog/core'

module Fog
  module DigitalOcean
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end

