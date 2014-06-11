module Fog
  module RiakCS
    class Provisioning
      class Real
        def create_user(email, name, options = {})
          payload = Fog::JSON.encode({ :email => email, :name => name })
          headers = { 'Content-Type' => 'application/json' }

          if(options[:anonymous])
            request(
              :expects => [201],
              :method  => 'POST',
              :path    => 'user',
              :body    => payload,
              :headers => headers
            )
          else
            begin
              response = @s3_connection.put_object('riak-cs', 'user', payload, headers)
              if !response.body.empty?
                case response.headers['Content-Type']
                when 'application/json'
                  response.body = Fog::JSON.decode(response.body)
                end
              end
              response
            rescue Excon::Errors::Conflict => e
              raise Fog::RiakCS::Provisioning::UserAlreadyExists.new
            rescue Excon::Errors::BadRequest => e
              raise Fog::RiakCS::Provisioning::ServiceUnavailable.new
            end
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
            raise Fog::RiakCS::Provisioning::ServiceUnavailable, "The email address you provided is not a valid."
          end

          if user_exists?(email)
            raise Fog::RiakCS::Provisioning::UserAlreadyExists, "User with email #{email} already exists."
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
