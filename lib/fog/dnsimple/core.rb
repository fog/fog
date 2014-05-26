require 'fog/core'
require 'fog/json'

module Fog
  module DNSimple
    extend Fog::Provider

    service(:dns, 'DNS')
  end
end
