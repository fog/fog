require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module DNSMadeEasy

    extend Fog::Provider

    service(:dns, 'dnsmadeeasy/dns', 'DNS')

  end
end
