require 'fog/core'

module Fog
  module Ninefold

    extend Fog::Provider

    service(:compute, 'ninefold/compute', 'Compute')
    service(:storage, 'ninefold/storage', 'Storage')

  end
end
