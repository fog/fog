module Fog
  module Compute
    class Linode
      class Real

        def linode_boot(linode_id, config_id)
          request(
            :expects => 200,
            :method => 'GET',
            :query => { :api_action => 'linode.boot', :linodeId => linode_id, :configId => config_id }
          )
        end

      end
    end
  end
end
