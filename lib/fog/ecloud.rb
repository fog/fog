require 'fog/core'

module Fog
  module Ecloud

    extend Fog::Provider

    service(:compute, 'compute/ecloud')

  end
end
