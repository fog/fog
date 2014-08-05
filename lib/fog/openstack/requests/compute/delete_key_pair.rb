module Fog
  module Compute
    class OpenStack
      class Real
        def delete_key_pair(key_name)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def delete_key_pair(key_name)
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
