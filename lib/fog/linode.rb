require 'fog/core'

module Fog
  module Linode
    extend Fog::Provider
    service(:compute, 'compute/linode')
    service(:dns,     'linode/dns')
  end
end

