require 'fog/core'

module Fog
  module DNSMadeEasy

    extend Fog::Provider

    service(:dns, 'dns/dnsmadeeasy')

  end
end
