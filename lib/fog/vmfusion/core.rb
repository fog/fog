require 'fog/core'

module Fog
  module Vmfusion

    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
