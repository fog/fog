module Fog
  module Compute
    class Linode
      class Real

        def linode_ip_list(linode_id, ip_id=nil)
          options = {}
          if ip_id
            options.merge!(:ipaddressId => ip_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.ip.list', :linodeId => linode_id }.merge!(options)
          )
        end

      end
    end
  end
end
