module Fog
  module Terremark
    class Real

      # Get details for a public ip
      #
      # ==== Parameters
      # * public_ip_id<~Integer> - Id of public ip to look up
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'PublicIpAddresses'<~Array>
      #       * 'href'<~String> - linke to item
      #       * 'name'<~String> - name of item
      def get_public_ip(public_ip_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Terremark::PublicIp.new,
          :path     => "publicIps/#{public_ip_id}"
        )
      end

    end

    class Mock

      def get_public_ip(public_ip_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
