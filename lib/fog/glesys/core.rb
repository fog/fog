require 'fog/core'

module Fog
  module Glesys

    extend Fog::Provider

    service(:compute, 'glesys/compute', 'Compute')

  end
end
