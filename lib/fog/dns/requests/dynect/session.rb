module Fog
  module Dynect
    class DNS
      class Real
        def session
          builder = Builder::XmlMarkup.new
          xml = builder.parameters do |root|
            root.customer_name(@dynect_customer)
            root.user_name( @dynect_username)
            root.password(@dynect_password)
          end

          request(
                  :expects  => 200,
                  :method   => "POST",
                  :path     => "/REST/Session/",
                  :body =>  xml
                  )
        end
      end

      class Mock

        def session
          response = Excon::Response.new
          response.status = 200
          response.body = {
          }
          response
        end

      end

    end
  end
end
