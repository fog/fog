require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module DNSimple

    extend Fog::Provider

    service(:dns, 'dnsimple/dns')

  end
end
