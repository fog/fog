module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vms'
        
        def get_vms(vapp_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::Vms.new,
            :path     => "vApp/#{vapp_id}"
          )
        end

      end
    end
  end
end
