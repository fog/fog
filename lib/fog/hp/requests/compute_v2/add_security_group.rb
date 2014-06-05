module Fog
  module Compute
    class HPV2
      class Real
        # Add an existing security group to an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server
        # * 'sg_name'<~String> - Name of security group to add to the server
        #
        def add_security_group(server_id, sg_name)
          body = { 'addSecurityGroup' => { 'name' => sg_name }}
          server_action(server_id, body)
        end
      end

      class Mock
        def add_security_group(server_id, sg_name)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            data = {"name" => "#{sg_name}"}
            if server['security_groups']
              server['security_groups'] << data
            else
              server['security_groups'] = data
            end
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
