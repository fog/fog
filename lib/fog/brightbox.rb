require 'fog/core'

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'brightbox/compute', 'Compute')

  end
end
