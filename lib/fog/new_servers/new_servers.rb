require 'fog/core'

module Fog
  module NewServers

    extend Fog::Provider

    service(:compute, 'compute/new_servers')

  end
end
