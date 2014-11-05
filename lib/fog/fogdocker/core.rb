require 'fog/core'
require 'fog/fogdocker/errors'

module Fog
  module Fogdocker
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end
