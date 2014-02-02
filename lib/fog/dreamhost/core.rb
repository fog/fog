require 'fog/core'

module Fog
  module Dreamhost

    extend Fog::Provider

    service(:dns, 'dreamhost/dns', 'DNS')

  end
end
