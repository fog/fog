module Fog
  module Dynect
    class DNS
      class Real

        require 'fog/dns/parsers/dynect/session'

        def session
          builder = Builder::XmlMarkup.new
          xml = builder.parameters do |root|
            root.customer_name(@dynect_customer)
            root.user_name( @dynect_username)
            root.password(@dynect_password)
          end

          request(
                  :parser   => Fog::Parsers::Dynect::DNS::Session.new,
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
            'API-Version' => '2.3.1',
            'API-Token' => 'thetoken=='
          }
          response
        end

      end

    end
  end
end
