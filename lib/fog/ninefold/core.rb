require 'fog/core'
require 'fog/json'

module Fog
  module Ninefold
    extend Fog::Provider

    service(:compute, 'Compute')
    service(:storage, 'Storage')
  end
end
