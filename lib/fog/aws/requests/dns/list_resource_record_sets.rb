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
        #   * identifier<~String> -
        #   * max_items<~Integer> -
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResourceRecordSet'<~Array>:
        #       * 'Name'<~String> -
        #       * 'Type'<~String> -
        #       * 'TTL'<~Integer> -
        #       * 'AliasTarget'<~Hash> -
        #         * 'HostedZoneId'<~String> -
        #         * 'DNSName'<~String> -
        #       * 'ResourceRecords'<~Array>
        #         * 'Value'<~String> -
        #     * 'IsTruncated'<~String> -
        #     * 'MaxItems'<~String> -
        #     * 'NextRecordName'<~String>
        #     * 'NextRecordType'<~String>
        #     * 'NextRecordIdentifier'<~String>
        #   * status<~Integer> - 201 when successful
        def list_resource_record_sets(zone_id, options = {})

          # AWS methods return zone_ids that looks like '/hostedzone/id'.  Let the caller either use
          # that form or just the actual id (which is what this request needs)
          zone_id = zone_id.sub('/hostedzone/', '')

          parameters = {}
          options.each do |option, value|
            case option
            when :type, :name, :identifier
              parameters[option] = "#{value}"
            when :max_items
              parameters['maxitems'] = "#{value}"
            end
          end

          request({
            :query   => parameters,
            :parser  => Fog::Parsers::DNS::AWS::ListResourceRecordSets.new,
            :expects => 200,
            :method  => 'GET',
            :path    => "hostedzone/#{zone_id}/rrset"
          })

        end

      end

      class Mock

        def list_resource_record_sets(zone_id, options = {})
          maxitems = [options[:max_items]||100,100].min

          response = Excon::Response.new

          zone = self.data[:zones][zone_id]
          if zone.nil?
            response.status = 404
            response.body = "<?xml version=\"1.0\"?>\n<ErrorResponse xmlns=\"https://route53.amazonaws.com/doc/2012-02-29/\"><Error><Type>Sender</Type><Code>NoSuchHostedZone</Code><Message>No hosted zone found with ID: #{zone_id}</Message></Error><RequestId>#{Fog::AWS::Mock.request_id}</RequestId></ErrorResponse>"
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end

          if options[:type]
            records = zone[:records][options[:type]].values
          else
            records = zone[:records].values.map{|r| r.values}.flatten
          end

          # sort for pagination
          records.sort! { |a,b| a[:name].gsub(zone[:name],"") <=> b[:name].gsub(zone[:name],"") }

          if options[:name]
            name = options[:name].gsub(zone[:name],"")
            records = records.select{|r| r[:name].gsub(zone[:name],"") >= name }
            require 'pp'
          end

          next_record  = records[maxitems]
          records      = records[0, maxitems]
          truncated    = !next_record.nil?

          response.status = 200
          response.body = {
            'ResourceRecordSets' => records.map do |r|
              if r[:alias_target]
                record = {
                  'AliasTarget' => {
                    'HostedZoneId' => r[:alias_target][:hosted_zone_id],
                    'DNSName' => r[:alias_target][:dns_name]
                  }
                }
              else
                record = {
                  'TTL' => r[:ttl]
                }
              end
              {
                'ResourceRecords' => r[:resource_records],
                'Name' => r[:name],
                'Type' => r[:type]
              }.merge(record)
            end,
            'MaxItems' => maxitems,
            'IsTruncated' => truncated
          }

          if truncated
            response.body['NextRecordName'] = next_record[:name]
            response.body['NextRecordType'] = next_record[:type]
          end

          response
        end

      end
    end
  end
end
