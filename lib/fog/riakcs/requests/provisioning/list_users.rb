module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def list_users(options = {})
          response      = @s3_connection.get_object('riak-cs', 'users', { 'Accept' => 'application/json', 'query' => options })

          boundary      = extract_boundary(response.headers['Content-Type'])
          parts         = parse(response.body, boundary)
          decoded       = parts.map { |part| Fog::JSON.decode(part[:body]) }

          response.body = decoded.flatten

          response
        end
      end

      class Mock
        def list_users(options = {})
          filtered_data = options[:status] ? data.select { |key, value| value[:status] == options[:status] } : data

          Excon::Response.new.tap do |response|
            response.status = 200
            response.body   = filtered_data.map do |key, value|
              {
                "email"        => value[:email],
                "display_name" => value[:name],
                "name"         => "user123",
                "key_id"       => key,
                "key_secret"   => value[:key_secret],
                "id"           => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                "status"       => value[:status]
              }
            end.compact
          end
        end
      end
    end
  end
end
