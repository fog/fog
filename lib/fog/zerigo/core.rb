require 'fog/core'

module Fog
  module Zerigo

    extend Fog::Provider

    service(:dns, 'zerigo/dns', 'DNS')

  end
end
