module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def get_user(user_id)
          response = @s3_connection.get_object('radosgw', "user/#{user_id}", { 'Accept' => 'application/json' })
          response.body = Fog::JSON.decode(response.body)
          response
        end
      end

      class Mock
        def get_user(user_id)
          if user = data[user_id]
            Excon::Response.new.tap do |response|
              response.status = 200
              response.headers['Content-Type'] = 'application/json'
              response.body = {
                "email"        => user[:email],
                "display_name" => user[:user_id],
                "user_id"      => user[:user_id],
                "key_secret"   => user[:key_secret],
                "suspended"       => user[:suspended]
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
