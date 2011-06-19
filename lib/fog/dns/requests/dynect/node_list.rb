module Fog
  module Dynect
    class DNS
      class Real

        require 'fog/dns/parsers/dynect/node_list'

        def node_list(zone)
          request(
                  :parser   => Fog::Parsers::Dynect::DNS::NodeList.new,
                  :expects  => 200,
                  :method   => "GET",
                  :path     => "NodeList/#{zone}",
                  )
        end
      end

      class Mock

        def node_list(zone)
          response = Excon::Response.new
          response.status = 200
          response.body = [zone]
          response
        end

      end

    end
  end
end
