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

        def create_user(email, name, options = {})
          if invalid_email?(email)
            raise Fog::Radosgw::Provisioning::ServiceUnavailable, "The email address you provided is not a valid."
          end

          if user_exists?(email)
            raise Fog::Radosgw::Provisioning::UserAlreadyExists, "User with email #{email} already exists."
          end

          key_id       = rand(1000).to_s
          key_secret   = rand(1000).to_s
          data[key_id] = { :email => email, :name => name, :status => 'enabled', :key_secret => key_secret }

          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = {
              "email"        => data[:email],
              "display_name" => data[:name],
              "name"         => "user123",
              "key_id"       => key_id,
              "key_secret"   => key_secret,
              "id"           => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
              "status"       => "enabled"
            }
          end
        end
      end
    end
  end
end
