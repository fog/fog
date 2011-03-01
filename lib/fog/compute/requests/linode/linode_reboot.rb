module Fog
  module Linode
    class Compute
      class Real
        def linode_reboot(linode_id, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.reboot', :linodeId => linode_id }.merge!(options)
          )
        end
      end
    end
  end
end
