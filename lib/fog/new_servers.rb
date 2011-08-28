require 'fog/core'

module Fog
  module NewServers

    extend Fog::Provider

    service(:compute, 'new_servers/compute')

  end
end
