require 'fog/core'

module Fog
  module GCE
    extend Fog::Provider

    service(:compute, 'gce/compute', 'Compute')

  end
end
