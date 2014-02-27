require 'fog/core'
require 'fog/json'

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
