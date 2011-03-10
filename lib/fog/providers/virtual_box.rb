require 'fog/core'

module Fog
  module VirtualBox

    extend Fog::Provider

    service(:compute, 'compute/virtual_box')

  end
end
