module Fog
  module HP
    class Network
      class Real
        # Delete a security group
        #
        # ==== Parameters
        # * 'security_group_id'<~String> - UUId of the security group to delete
        def delete_security_group(security_group_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "security-groups/#{security_group_id}"
          )
        end
      end

      class Mock
        def delete_security_group(security_group_id)
          response = Excon::Response.new
          if self.data[:security_groups][security_group_id]
            self.data[:security_groups].delete(security_group_id)
            response.status = 204
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
