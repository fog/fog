require 'fog/core'
require 'fog/json'

module Fog
  module Dreamhost
    extend Fog::Provider

    service(:dns, 'DNS')
  end
end
