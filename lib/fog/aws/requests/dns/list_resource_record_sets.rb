module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/list_resource_record_sets'

        # list your resource record sets
        #
        # ==== Parameters
        # * zone_id<~String> - 
        # * options<~Hash>
        #   * type<~String> - 
        #   * name<~String> -
        #   * max_items<~Integer> - 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResourceRecordSet'<~Array>:
        #       * 'Name'<~String> - 
        #       * 'Type'<~String> - 
        #       * 'TTL'<~Integer> - 
        #       * 'ResourceRecords'<~Array>
        #         * 'Value'<~String> - 
        #     * 'IsTruncated'<~String> - 
        #     * 'MaxItems'<~String> - 
        #     * 'NextRecordName'<~String>
        #     * 'NexRecordType'<~String>
        #   * status<~Integer> - 201 when successful
        def list_resource_record_sets(zone_id, options = {})

          # AWS methods return zone_ids that looks like '/hostedzone/id'.  Let the caller either use 
          # that form or just the actual id (which is what this request needs)
          zone_id = zone_id.sub('/hostedzone/', '')

          parameters = {}
          options.each { |option, value|
            case option
            when :type, :name
              parameters[option]= "#{value}"
            when :max_items
              parameters['maxitems']= "#{value}"
            end
          }
          
          request({
            :query => parameters,
            :parser     => Fog::Parsers::DNS::AWS::ListResourceRecordSets.new,
            :expects    => 200,
            :method     => 'GET',
            :path       => "hostedzone/#{zone_id}/rrset"
          })

        end

      end
    end
  end
end
