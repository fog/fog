require 'fog/core'

module Fog
  module DNSimple

    extend Fog::Provider

    service(:dns, 'DNS')

  end
end
