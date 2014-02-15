require 'fog/core'

module Fog
  module CloudSigma
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
