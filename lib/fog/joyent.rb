require 'fog/joyent/compute'
require 'fog/joyent/errors'
require 'fog/core'

module Fog
  module Joyent
    extend Fog::Provider

    service(:analytics, 'Analytics')
    service(:compute, 'Compute')
  end
end
