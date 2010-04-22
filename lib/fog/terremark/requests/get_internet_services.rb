module Fog
  module Terremark
    class Real

      require 'fog/terremark/parsers/get_internet_services'

      # Get a list of all internet services for a vdc
      #
      # ==== Parameters
      # * vdc_id<~Integer> - Id of vDc to get list of internet services for
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'InternetServices'<~Array>
      #       * 'id'<~String> => id of the internet service
      #       * 'name'<~String> => name of service
      #       * 'PublicIPAddress'<~Hash>
      #       *   'Id'<~String> => id of the public IP
      #       *   'name'<~String> => actual ip address
      #
      def get_internet_services(vdc_id = default_vdc_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Terremark::GetInternetServices.new,
          :path     => "vdc/#{vdc_id}/internetServices"
        )
      end

    end

    class Mock

      def get_internet_services(vdc_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
