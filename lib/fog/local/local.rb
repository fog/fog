require 'fog/core'

module Fog
  module Local

    extend Fog::Provider

    service(:storage, 'storage/local')

  end
end
