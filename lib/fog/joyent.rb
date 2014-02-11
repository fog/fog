require 'fog/joyent/compute'
require 'fog/joyent/errors'
require 'fog/core'

module Fog
  module Joyent
    extend Fog::Provider

    service(:analytics, 'joyent/analytics', 'Analytics')
    service(:compute, 'joyent/compute', 'Compute')

  end
end
