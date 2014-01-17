require 'fog/core'

module Fog
  module Rage4

    extend Fog::Provider

    service(:dns, 'rage4/dns', 'DNS')

  end
end
