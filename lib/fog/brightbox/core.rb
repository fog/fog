require 'fog/core'

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
