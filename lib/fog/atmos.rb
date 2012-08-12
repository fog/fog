require 'fog/core'

module Fog
  module Atmos

    extend Fog::Provider

    service(:storage, 'atmos/storage', 'Storage')

  end
end
