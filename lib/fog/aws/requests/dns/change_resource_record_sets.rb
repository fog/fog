module Fog
  module DNS
    class AWS
      class Real

        require 'fog/aws/parsers/dns/change_resource_record_sets'

        # Use this action to create or change your authoritative DNS information for a zone
        # http://docs.amazonwebservices.com/Route53/latest/DeveloperGuide/RRSchanges.html#RRSchanges_API
        #
        # ==== Parameters
        # * zone_id<~String> - ID of the zone these changes apply to
        # * options<~Hash>
        #   * comment<~String> - Any comments you want to include about the change.
        # * change_batch<~Array> - The information for a change request
        #   * changes<~Hash> -
        #     * action<~String> - 'CREATE' or 'DELETE'
        #     * name<~String>   - This must be a fully-specified name, ending with a final period
        #     * type<~String>   - A | AAAA | CNAME | MX | NS | PTR | SOA | SPF | SRV | TXT
        #     * ttl<~Integer>   - Time-to-live value - omit if using an alias record
        #     * resource_records<~Array> - Omit if using an alias record
        #     * alias_target<~Hash> - Information about the domain to which you are redirecting traffic (Alias record sets only)
        #       * dns_name<~String> - The Elastic Load Balancing domain to which you want to reroute traffic
        #       * hosted_zone_id<~String> - The ID of the hosted zone that contains the Elastic Load Balancing domain to which you want to reroute traffic
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ChangeInfo'<~Hash>
        #       * 'Id'<~String> - The ID of the request
        #       * 'Status'<~String> - status of the request - PENDING | INSYNC
        #       * 'SubmittedAt'<~String> - The date and time the change was made
        #   * status<~Integer> - 200 when successful
        #
        # ==== Examples
        #
        # Example changing a CNAME record:
        #
        #     change_batch_options = [
        #       {
        #         :action => "DELETE",
        #         :name => "foo.example.com.",
        #         :type => "CNAME",
        #         :ttl => 3600,
        #         :resource_records => [ "baz.example.com." ]
        #       },
        #       {
        #         :action => "CREATE",
        #         :name => "foo.example.com.",
        #         :type => "CNAME",
        #         :ttl => 3600,
        #         :resource_records => [ "bar.example.com." ]
        #       }
        #     ]
        #
        #     change_resource_record_sets("ABCDEFGHIJKLMN", change_batch_options)
        #
        def change_resource_record_sets(zone_id, change_batch, options = {})

          # AWS methods return zone_ids that looks like '/hostedzone/id'.  Let the caller either use
          # that form or just the actual id (which is what this request needs)
          zone_id = zone_id.sub('/hostedzone/', '')

          optional_tags = ''
          options.each do |option, value|
            case option
            when :comment
              optional_tags += "<Comment>#{value}</Comment>"
            end
          end

          #build XML
          if change_batch.count > 0

            changes = "<ChangeBatch>#{optional_tags}<Changes>"

            change_batch.each do |change_item|
              action_tag = %Q{<Action>#{change_item[:action]}</Action>}
              name_tag   = %Q{<Name>#{change_item[:name]}</Name>}
              type_tag   = %Q{<Type>#{change_item[:type]}</Type>}

              # TTL must be omitted if using an alias record
              ttl_tag = ''
              ttl_tag += %Q{<TTL>#{change_item[:ttl]}</TTL>} unless change_item[:alias_target]

              weight_tag = ''
              set_identifier_tag = ''
              region_tag = ''
              if change_item[:set_identifier]
                set_identifier_tag += %Q{<SetIdentifier>#{change_item[:set_identifier]}</SetIdentifier>}
                if change_item[:weight] # Weighted Record
                  weight_tag += %Q{<Weight>#{change_item[:weight]}</Weight>}
                elsif change_item[:region] # Latency record
                  region_tag += %Q{<Region>#{change_item[:region]}</Region>}
                end
              end
              resource_records = change_item[:resource_records] || []
              resource_record_tags = ''
              resource_records.each do |record|
                resource_record_tags += %Q{<ResourceRecord><Value>#{record}</Value></ResourceRecord>}
              end

              # ResourceRecords must be omitted if using an alias record
              resource_tag = ''
              resource_tag += %Q{<ResourceRecords>#{resource_record_tags}</ResourceRecords>} if resource_records.any?

              alias_target_tag = ''
              if change_item[:alias_target]
                # Accept either underscore or camel case for hash keys.
                dns_name = change_item[:alias_target][:dns_name] || change_item[:alias_target][:DNSName]
                hosted_zone_id = change_item[:alias_target][:hosted_zone_id] || change_item[:alias_target][:HostedZoneId] || AWS.hosted_zone_for_alias_target(dns_name)
                alias_target_tag += %Q{<AliasTarget><HostedZoneId>#{hosted_zone_id}</HostedZoneId><DNSName>#{dns_name}</DNSName></AliasTarget>}
              end

              change_tags = %Q{<Change>#{action_tag}<ResourceRecordSet>#{name_tag}#{type_tag}#{set_identifier_tag}#{weight_tag}#{region_tag}#{ttl_tag}#{resource_tag}#{alias_target_tag}</ResourceRecordSet></Change>}
              changes += change_tags
            end

            changes += '</Changes></ChangeBatch>'
          end


          body = %Q{<?xml version="1.0" encoding="UTF-8"?><ChangeResourceRecordSetsRequest xmlns="https://route53.amazonaws.com/doc/#{@version}/">#{changes}</ChangeResourceRecordSetsRequest>}
          request({
            :body       => body,
            :parser     => Fog::Parsers::DNS::AWS::ChangeResourceRecordSets.new,
            :expects    => 200,
            :method     => 'POST',
            :path       => "hostedzone/#{zone_id}/rrset"
          })

        end

      end

      class Mock

        def change_resource_record_sets(zone_id, change_batch, options = {})
          response = Excon::Response.new
          errors   = []

          if (zone = self.data[:zones][zone_id])
            response.status = 200

            change_batch.each do |change|
              case change[:action]
              when "CREATE"
                if zone[:records][change[:type]].nil?
                  zone[:records][change[:type]] = {}
                end

                if zone[:records][change[:type]][change[:name]].nil?
                  zone[:records][change[:type]][change[:name]] = {
                    :name => change[:name],
                    :type => change[:type],
                    :ttl => change[:ttl],
                    :resource_records => change[:resource_records]
                  }
                else
                  errors << "Tried to create resource record set #{change[:name]}. type #{change[:type]}, but it already exists"
                end
              when "DELETE"
                if zone[:records][change[:type]].nil? || zone[:records][change[:type]].delete(change[:name]).nil?
                  errors << "Tried to delete resource record set #{change[:name]}. type #{change[:type]}, but it was not found"
                end
              end
            end

            if errors.empty?
              response.body = {
                'ChangeInfo' => {
                  'Id' => "/change/#{Fog::AWS::Mock.change_id}",
                  'Status' => 'INSYNC',
                  'SubmittedAt' => Time.now.utc.iso8601
                }
              }
              response
            else
              response.status = 400
              response.body = "<?xml version=\"1.0\"?><InvalidChangeBatch xmlns=\"https://route53.amazonaws.com/doc/2012-02-29/\"><Messages>#{errors.map {|e| "<Message>#{e}</Message>"}.join()}</Messages></InvalidChangeBatch>"
              raise(Excon::Errors.status_error({:expects => 200}, response))
            end
          else
            response.status = 404
            response.body = "<?xml version=\"1.0\"?><Response><Errors><Error><Code>NoSuchHostedZone</Code><Message>A hosted zone with the specified hosted zone ID does not exist.</Message></Error></Errors><RequestID>#{Fog::AWS::Mock.request_id}</RequestID></Response>"
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
        end
      end

      def self.hosted_zone_for_alias_target(dns_name)
        k = elb_hosted_zone_mapping.keys.find do |k|
          dns_name =~ /\A.+\.#{k}\.elb\.amazonaws\.com\.?\z/
        end
        elb_hosted_zone_mapping[k]
      end

      def self.elb_hosted_zone_mapping
        @elb_hosted_zone_mapping ||= {
          "ap-northeast-1" => "Z2YN17T5R711GT",
          "ap-southeast-1" => "Z1WI8VXHPB1R38",
          "eu-west-1"      => "Z3NF1Z3NOM5OY2",
          "sa-east-1"      => "Z2ES78Y61JGQKS",
          "us-east-1"      => "Z3DZXE0Q79N41H",
          "us-west-1"      => "Z1M58G0W56PQJA",
          "us-west-2"      => "Z33MTJ483KN6FU",
        }
      end
    end
  end
end
