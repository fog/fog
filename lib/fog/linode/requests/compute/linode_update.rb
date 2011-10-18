module Fog
  module Compute
    class Linode
      class Real

        def linode_update(linode_id, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.update', :linodeId => linode_id }.merge!(options)
          )
        end

      end
    end
  end
end
