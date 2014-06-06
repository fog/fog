module Fog
  module Compute
    class HPV2
      class Real
        # Remove an existing security group from an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server
        # * 'sg_name'<~String> - Name of security group to remove from the server
        #
        def remove_security_group(server_id, sg_name)
          body = { 'removeSecurityGroup' => { 'name' => sg_name }}
          server_action(server_id, body)
        end
      end

      class Mock
        def remove_security_group(server_id, sg_name)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            data = server['security_groups'].reject {|sg| sg['name'] == sg_name}
            self.data[:servers][server_id]['security_groups'] = data

            response.status = 202
          else
            raise Fog::Compute::HPV2::NotFound
          end
          response
        end
      end
    end
  end
end
