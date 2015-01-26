require 'fog/core'
require 'fog/json'

module Fog
  module Joyent
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
