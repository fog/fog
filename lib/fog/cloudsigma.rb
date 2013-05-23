require 'fog/core'

module Fog
  module CloudSigma
    extend Fog::Provider

    service(:compute, 'cloudsigma/compute', 'Compute')
  end
end
