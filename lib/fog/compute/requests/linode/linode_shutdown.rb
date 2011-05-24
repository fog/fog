module Fog
  module Linode
    class Compute
      class Real
        def linode_shutdown(linode_id)
          request(
            :expects => 200,
            :method => 'GET',
            :query => { :api_action => 'linode.shutdown', :linodeId => linode_id }
          )
        end
      end
    end
  end
end
