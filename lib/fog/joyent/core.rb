require 'fog/core'

module Fog
  module Joyent
    extend Fog::Provider

    service(:compute, 'Compute')

  end
end
