require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module NewServers

    extend Fog::Provider

    service(:compute, 'new_servers/compute')

  end
end
