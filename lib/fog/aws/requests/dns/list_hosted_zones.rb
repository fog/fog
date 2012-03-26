module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/list_hosted_zones'

        # Describe all or specified instances
        #
        # ==== Parameters
        # * options<~Hash>
        #   * marker<~String> - Indicates where to begin in your list of hosted zones.
        #   * max_items<~Integer> - The maximum number of hosted zones to be included in the response body
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'HostedZones'<~Array>:
        #       * 'HostedZone'<~Hash>:
        #         * 'Id'<~String> -
        #         * 'Name'<~String> -
        #         * 'CallerReference'<~String>
        #         * 'Comment'<~String> -
        #     * 'Marker'<~String> -
        #     * 'MaxItems'<~Integer> -
        #     * 'IsTruncated'<~String> -
        #     * 'NextMarket'<~String>
        #   * status<~Integer> - 200 when successful
        def list_hosted_zones(options = {})

          parameters = {}
          options.each do |option, value|
            case option
            when :marker
              parameters[option] = value
            when :max_items
              parameters[:maxitems] = value
            end
          end

          request({
            :query   => parameters,
            :parser  => Fog::Parsers::DNS::AWS::ListHostedZones.new,
            :expects => 200,
            :method  => 'GET',
            :path    => "hostedzone"
          })

        end

      end
    end
  end
end
