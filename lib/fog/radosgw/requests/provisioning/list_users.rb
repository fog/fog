module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def list_user_ids()
          path = "admin/metadata/user"
          query = "?format=json"
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
            else
              response.body = []
            end
            response
          rescue Excon::Errors::BadRequest => e
            raise Fog::Radosgw::Provisioning::ServiceUnavailable.new
          end
        end

        def list_users(options = {})
          response = list_user_ids
          response.body = response.body.map { |user_id| get_user(user_id).body }
          if options[:suspended]
            response.body = response.body.select { |user| user[:suspended] == options[:suspended] }
          end
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
