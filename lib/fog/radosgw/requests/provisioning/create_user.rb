module Fog
  module Radosgw
    class Provisioning
      class Real
        def create_user(email, user_id, options = {})
          path = "admin/user"
          user_id = Fog::AWS.escape(user_id)
          query = "?uid=#{user_id}&display-name=#{user_id}&format=json"
          expires = Fog::Time.now.to_date_header
          params = { 
            :method => 'PUT',
            :path => path,
          }
          auth   =  @s3_connection.signature(params,expires)
          awskey =  @radosgw_access_key_id
          headers = {
            'Date'          => expires,
            'Authorization' => "AWS #{awskey}:#{auth}"
          }

          begin
            response = Excon.put("#{@scheme}://#{@host}/#{path}#{query}",
                                 :headers => headers)
            if !response.body.empty?
              case response.headers['Content-Type']
              when 'application/json'
                response.body = Fog::JSON.decode(response.body)
              end
              response
            end
          rescue Excon::Errors::Conflict => e
            raise Fog::Radosgw::Provisioning::UserAlreadyExists.new
          rescue Excon::Errors::BadRequest => e
            raise Fog::Radosgw::Provisioning::ServiceUnavailable.new
          end
        end
      end

      class Mock
        def invalid_email?(email)
          !email.include?('@')
        end

        def user_exists?(email)
          data.find do |key, value|
            value[:email] == email
          end
        end

        def create_user(email, user_id, options = {})
          if invalid_email?(email)
            raise Fog::Radosgw::Provisioning::ServiceUnavailable, "The email address you provided is not a valid."
          end

          if user_exists?(email)
            raise Fog::Radosgw::Provisioning::UserAlreadyExists, "User with email #{email} already exists."
          end

          secret_key   = rand(1000).to_s
          data[user_id] = { :email => email, :user_id => user_id, :suspended => 0, :secret_key => secret_key }

          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = {
              "email"        => email,
              "display_name" => user_id,
              "user_id"      => user_id,
              "suspended"    => 0,
              "keys"         =>
              [
               {
                 "access_key" => "XXXXXXXXXXXXXXXXXXXX",
                 "secret_key" => secret_key,
                 "user"       => user_id,
               }
              ],
            }
          end
        end
      end
    end
  end
end
