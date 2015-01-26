require 'fog/core'
require 'fog/json'

module Fog
  module Glesys
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
