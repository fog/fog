module Fog
  module Vcloud
    module Shared
      def shared_requires
        require 'fog/vcloud/models/shared/address'
        require 'fog/vcloud/models/shared/addresses'
        require 'fog/vcloud/models/shared/network'
        require 'fog/vcloud/models/shared/networks'
        require 'fog/vcloud/models/shared/server'
        require 'fog/vcloud/models/shared/servers'
        require 'fog/vcloud/models/shared/task'
        require 'fog/vcloud/models/shared/tasks'
        require 'fog/vcloud/models/shared/vdc'
        require 'fog/vcloud/models/shared/vdcs'
      end
    end
  end
end
