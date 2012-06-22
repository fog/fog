require 'fog/core'

module Fog
  module DNSMadeEasy

    extend Fog::Provider

    service(:dns, 'dnsmadeeasy/dns', 'DNS')

  end
end
