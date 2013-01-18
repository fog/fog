module Fog
  module Compute
    class OpenStack
      class Real

        def delete_security_group_rule(security_group_rule_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-security-group-rules/#{security_group_rule_id}"
          )
        end

      end

      class Mock
        def delete_security_group_rule(security_group_rule_id)
          response = Excon::Response.new
          response.status = 202
          response.headers = {
            "Content-Type" => "text/html; charset=UTF-8",
            "Content-Length" => "0",
            "Date" => Date.new
          }
          response.body = {}
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
