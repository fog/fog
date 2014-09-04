module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def list_users(options = {})
          response      = @s3_connection.get_object('radosgw', 'users', { 'Accept' => 'application/json', 'query' => options })

          boundary      = extract_boundary(response.headers['Content-Type'])
          parts         = parse(response.body, boundary)
          decoded       = parts.map { |part| Fog::JSON.decode(part[:body]) }

          response.body = decoded.flatten

          response
        end
      end

      class Mock
        def list_users(options = {})
          filtered_data = options[:suspended] ? data.select { |key, value| value[:suspended] == options[:suspended] } : data

          Excon::Response.new.tap do |response|
            response.status = 200
            response.body   = filtered_data.map do |key, value|
              {
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
            end.compact
          end
        end
      end
    end
  end
end