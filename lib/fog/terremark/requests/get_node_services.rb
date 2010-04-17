module Fog
  module Terremark
    class Real

      require 'fog/terremark/parsers/get_node_services'

      # Get a list of all internet services for a vdc
      #
      # ==== Parameters
      # * service_id<~Integer> - Id of internet service that we want a list of nodes for
       #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
     
      #       
      def get_node_services(service_id)
         request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Terremark::GetNodeServices.new,
          :path     => "InternetServices/#{service_id}/nodes"
        )
      end

    end

    class Mock

      def get_node_services(vdc_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
