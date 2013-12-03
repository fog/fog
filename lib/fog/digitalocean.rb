require 'fog/core'

module Fog
  module DigitalOcean
    extend Fog::Provider
    service(:compute, 'digitalocean/compute', 'Compute')
  end
end

