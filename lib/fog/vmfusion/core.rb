require 'fog/core'

module Fog
  module Vmfusion

    extend Fog::Provider

    service(:compute, 'vmfusion/compute', 'Compute')

  end
end
