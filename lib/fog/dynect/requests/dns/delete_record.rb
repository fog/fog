module Fog
  module DNS
    class Dynect
      class Real

        # Delete a record
        #
        # ==== Parameters
        # * type<~String> - type of record in ['AAAA', 'ANY', 'A', 'CNAME', 'DHCID', 'DNAME', 'DNSKEY', 'DS', 'KEY', 'LOC', 'MX', 'NSA', 'NS', 'PTR', 'PX', 'RP', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TXT']
        # * zone<~String> - zone of record
        # * fqdn<~String> - fqdn of record
        # * record_id<~String> - id of record

        def delete_record(type, zone, fqdn, record_id)
          request(
            :expects  => 200,
            :idempotent => true,
            :method   => :delete,
            :path     => ["#{type.to_s.upcase}Record", zone, fqdn, record_id].join('/')
          )
        end
      end

      class Mock
        def delete_record(type, zone, fqdn, record_id)
          raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][zone]

          raise Fog::DNS::Dynect::NotFound unless zone[:records][type].find { |record| record[:fqdn] == fqdn && record[:record_id] == record_id.to_i }

          zone[:records_to_delete] << {
            :type => type,
            :fqdn => fqdn,
            :record_id => record_id.to_i
          }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            "status" => "success",
            "data" => {},
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "INFO" => "delete: Record will be deleted on zone publish",
              "SOURCE" => "BLL",
              "ERR_CD" => nil,
              "LVL" => "INFO"
            }]
          }

          response
        end
      end
    end
  end
end
