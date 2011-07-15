require 'fog/core'

module Fog
  module Vcloud

    extend Fog::Provider

    service(:compute, 'compute/vcloud')

  end
end
