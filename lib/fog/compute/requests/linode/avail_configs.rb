module Fog
  module Linode
    class Compute
      class Real
        def avail_configs(linode_id, config_id=nil, options={})
          if config_id
            options.merge!(:configid => config_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.config.list', :linodeId => linode_id }.merge!(options)
          )
        end
      end
    end
  end
end
