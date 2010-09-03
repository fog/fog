require 'fog/credentials'

require 'fog/aws/bin'
require 'fog/go_grid/bin'
require 'fog/linode/bin'
require 'fog/local/bin'
require 'fog/new_servers/bin'
require 'fog/rackspace/bin'
require 'fog/slicehost/bin'
require 'fog/terremark/bin'
require 'fog/vcloud/bin'
require 'fog/bluebox/bin'

module Fog
  class << self

    def modules
      [
        ::AWS,
        ::GoGrid,
        ::Linode,
        ::Local,
        ::NewServers,
        ::Rackspace,
        ::Slicehost,
        ::Terremark,
        ::Vcloud,
        ::Bluebox
      ].select {|_module_| _module_.initialized?}

    end

  end
end
