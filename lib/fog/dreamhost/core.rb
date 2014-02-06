require 'fog/core'

module Fog
  module Dreamhost

    extend Fog::Provider

    service(:dns, 'DNS')

  end
end
