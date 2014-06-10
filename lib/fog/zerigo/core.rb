require 'fog/core'
require 'fog/xml'

module Fog
  module Zerigo
    extend Fog::Provider

    service(:dns, 'DNS')
  end
end
