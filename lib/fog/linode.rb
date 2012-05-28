require 'fog/core'

module Fog
  module Linode
    extend Fog::Provider
    service(:compute, 'linode/compute', 'Compute')
    service(:dns,     'linode/dns',     'DNS')
  end
end

