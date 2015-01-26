require 'fog/core'
require 'fog/json'

module Fog
  module Linode
    extend Fog::Provider
    service(:compute, 'Compute')
    service(:dns,     'DNS')
  end
end
