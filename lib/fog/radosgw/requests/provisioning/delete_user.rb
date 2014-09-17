module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils

        def delete_user(user_id)
          path         = "admin/user"
          user_id      = Fog::AWS.escape(user_id)
          query        = "?uid=#{user_id}&format=json"
          params       = {
            :method => 'DELETE',
            :path => path,
          }

          begin
            response = Excon.delete("#{@scheme}://#{@host}/#{path}#{query}",
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
        def user_exists?(user_id)
          data.find do |key, value|
            value[:user_id] == user_id
          end
        end

        def delete_user(user_id)
          if !user_exists?(user_id)
            raise Fog::Radosgw::Provisioning::NoSuchUser, "No user with user_id #{user_id} exists."
          end

          data.delete(user_id)

          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = ""
          end
        end
      end
    end
  end
end
