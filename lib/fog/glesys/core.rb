require 'fog/core'

module Fog
  module Glesys

    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
