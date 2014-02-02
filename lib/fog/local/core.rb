require 'fog/core'

module Fog
  module Local

    extend Fog::Provider

    service(:storage, 'local/storage', 'Storage')

  end
end
