module Fog
  module Linode
    class Compute
      class Real
        def linode_list(linode_id=nil)
          options = {}
          if linode_id
            options.merge!(:linodeId => linode_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.list' }.merge!(options)
          )
        end
      end
    end
  end
end
