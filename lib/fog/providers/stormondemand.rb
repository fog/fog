require 'fog/core'

module Fog
  module Stormondemand

    extend Fog::Provider

    service(:compute, 'compute/stormondemand')

  end
end

