module Fog
  module Compute
    class Linode
      class Real
        def linode_ip_addprivate(linode_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.ip.addprivate', :linodeId => linode_id }
          )
        end
      end
    end
  end
end
