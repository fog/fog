require 'fog/core'
require 'fog/json'

module Fog
  module Rage4
    extend Fog::Provider

    service(:dns, 'DNS')
  end
end
