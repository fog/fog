require 'fog/core'

module Fog
  module Linode
    extend Fog::Provider
    service(:compute, 'linode/compute')
    service(:dns,     'linode/dns')
  end
end

