require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Dreamhost 

    extend Fog::Provider

    service(:dns, 'dreamhost/dns', 'DNS')

  end
end
