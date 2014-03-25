require 'fog/core'
require 'fog/json'

module Fog
  module CloudSigma
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
