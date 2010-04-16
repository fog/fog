module Fog
  module Terremark
    module Shared
      module Real

        # Get list of public ips
        #
        # ==== Parameters
        # * vdc_id<~Integer> - Id of vdc to find public ips for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'PublicIpAddresses'<~Array>
        #       * 'href'<~String> - link to item
        #       * 'name'<~String> - name of item
        def get_public_ips(vdc_id)
          opts = {
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Terremark::Shared::GetPublicIps.new,
            :path     => "vdc/#{vdc_id}/publicIps"
          }
          if self.class == Fog::Terremark::Ecloud::Real
            opts[:path] = "extensions/vdc/#{vdc_id}/publicIps"
          end
          request(opts)
        end

      end

      module Mock

        def get_public_ips(vdc_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
