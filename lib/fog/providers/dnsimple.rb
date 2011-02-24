require 'fog/core'

module Fog
  module DNSimple

    extend Fog::Provider

    service(:dns, 'dns/dnsimple')

  end
end
