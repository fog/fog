require 'fog/core'

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'compute/brightbox')
  end
end
