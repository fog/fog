require 'fog/core'
require 'fog/xml'
require 'fog/json'

module Fog
  module Libvirt
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
