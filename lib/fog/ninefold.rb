require 'fog/core'

module Fog
  module Ninefold

    extend Fog::Provider

    service(:compute, 'ninefold/compute')
    service(:storage, 'ninefold/storage')

  end
end
