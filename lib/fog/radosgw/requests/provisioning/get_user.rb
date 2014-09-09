module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def get_user(user_id)
          path = "admin/user"
          user_id = Fog::AWS.escape(user_id)
          query = "?uid=#{user_id}&format=json"
          params = { 
            :method => 'GET',
            :path => path,
          }

          begin
            response = Excon.get("#{@scheme}://#{@host}/#{path}#{query}",
                                 :headers => signed_headers(params))
            if !response.body.empty?
              case response.headers['Content-Type']
              when 'application/json'
                response.body = Fog::JSON.decode(response.body)
              end
            end
            response
          rescue Excon::Errors::NotFound => e
            raise Fog::Radosgw::Provisioning::NoSuchUser.new
          rescue Excon::Errors::BadRequest => e
            raise Fog::Radosgw::Provisioning::ServiceUnavailable.new
          end
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
                "user_id"      => value[:user_id],
                "display_name" => value[:display_name],
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
