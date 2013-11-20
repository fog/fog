module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def get_user(key_id)
          response = @s3_connection.get_object('riak-cs', "user/#{key_id}", { 'Accept' => 'application/json' })
          response.body = Fog::JSON.decode(response.body)
          response
        end
      end

      class Mock
        def get_user(key_id)
          if user = data[key_id]
            Excon::Response.new.tap do |response|
              response.status = 200
              response.headers['Content-Type'] = 'application/json'
              response.body = {
                "email"        => user[:email],
                "display_name" => user[:name],
                "name"         => "user123",
                "key_id"       => "XXXXXXXXXXXXXXXXXXXX",
                "key_secret"   => user[:key_secret],
                "id"           => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                "status"       => user[:status]
              }
            end
          else
            Excon::Response.new.tap do |response|
              response.status = 404
              response.headers['Content-Type'] = 'application/json'
            end
          end
        end
      end
    end
  end
end
