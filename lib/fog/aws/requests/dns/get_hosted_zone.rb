module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/get_hosted_zone'

        # retrieve information about a hosted zone
        #
        # ==== Parameters
        # * zone_id<~String> - The ID of the hosted zone
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'HostedZone'<~Hash>:
        #       * 'Id'<~String> -
        #       * 'Name'<~String> -
        #       * 'CallerReference'<~String>
        #       * 'Comment'<~String> -
        #     * 'NameServers'<~Array>
        #       * 'NameServer'<~String>
        #   * status<~Integer> - 201 when successful
        def get_hosted_zone(zone_id)

          # AWS methods return zone_ids that looks like '/hostedzone/id'.  Let the caller either use
          # that form or just the actual id (which is what this request needs)
          zone_id = zone_id.sub('/hostedzone/', '')

          request({
            :expects => 200,
            :parser  => Fog::Parsers::DNS::AWS::GetHostedZone.new,
            :method  => 'GET',
            :path    => "hostedzone/#{zone_id}"
          })

        end

      end
    end
  end
end
