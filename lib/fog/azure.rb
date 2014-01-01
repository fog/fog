require 'fog/core'

module Fog
  module Azure
    extend Fog::Provider

    service(:compute, 'azure/compute', 'Compute')
    #puts 'here'
    #service(:storage, 'azure/storage', 'Storage')

  end
end
