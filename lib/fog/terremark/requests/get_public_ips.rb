module Fog
  module Terremark
    class Real

      require 'fog/terremark/parsers/get_public_ips'

      # Get list of public ips
      #
      # ==== Parameters
      # * vdc_id<~Integer> - Id of vdc to find public ips for
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'PublicIpAddresses'<~Array>
      #       * 'href'<~String> - linke to item
      #       * 'name'<~String> - name of item
      def get_public_ips(vdc_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Terremark::GetPublicIps.new,
          :path     => "vdc/#{vdc_id}/publicIps"
        )
      end

    end

    class Mock

      def get_public_ips(vdc_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
