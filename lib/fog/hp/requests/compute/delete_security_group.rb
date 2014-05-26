module Fog
  module Compute
    class HP
      class Real
        # Delete a security group
        #
        # ==== Parameters
        # * id<~Integer> - Id of the security group to delete
        #
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def delete_security_group(security_group_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-security-groups/#{security_group_id}"
          )
        end
      end

      class Mock
        def delete_security_group(security_group_id)
          response = Excon::Response.new
          if self.data[:security_groups][security_group_id]
            self.data[:last_modified][:security_groups].delete(security_group_id)
            self.data[:security_groups].delete(security_group_id)
            response.status = 202
            response.body = "202 Accepted\n\nThe request is accepted for processing.\n\n   "
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
