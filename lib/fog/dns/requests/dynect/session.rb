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
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
