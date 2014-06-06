require 'fog/core'

module Fog
  module Atmos
    extend Fog::Provider

    service(:storage, 'Storage')
  end
end
