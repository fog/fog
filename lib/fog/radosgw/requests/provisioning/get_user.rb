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
          if value = data[user_id]
            Excon::Response.new.tap do |response|
              response.status = 200
              response.headers['Content-Type'] = 'application/json'
              response.body = {
                "email"        => value[:email],
                "display_name" => value[:user_id],
                "user_id"      => value[:user_id],
                "suspended"    => value[:suspended],
                "keys"         =>
                [
                 {
                   "access_key" => "XXXXXXXXXXXXXXXXXXXX",
                   "secret_key" => value[:secret_key],
                   "user"       => value[:user_id],
                 }
                ],
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
