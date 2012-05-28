require 'fog/core'

module Fog
  module DNSimple

    extend Fog::Provider

    service(:dns, 'dnsimple/dns', 'DNS')

  end
end
