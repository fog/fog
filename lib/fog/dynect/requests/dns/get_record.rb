module Fog
  module DNS
    class Dynect
      class Real

        # List records of a given type
        #
        # ==== Parameters
        # * type<~String> - type of record in ['AAAA', 'ANY', 'A', 'CNAME', 'DHCID', 'DNAME', 'DNSKEY', 'DS', 'KEY', 'LOC', 'MX', 'NSA', 'NS', 'PTR', 'PX', 'RP', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TXT']
        # * zone<~String> - name of zone to lookup
        # * fqdn<~String> - name of fqdn to lookup
        # * options<~Hash>:
        #   * record_id<~String> - id of record

        def get_record(type, zone, fqdn, options = {})
          request(
            :expects  => 200,
            :idempotent => true,
            :method   => :get,
            :path     => ["#{type.to_s.upcase}Record", zone, fqdn, options['record_id']].compact.join('/')
          )
        end
      end

      class Mock
        def get_record(type, zone, fqdn, options = {})
          raise ArgumentError unless [
            'AAAA', 'ANY', 'A', 'CNAME',
            'DHCID', 'DNAME', 'DNSKEY',
            'DS', 'KEY', 'LOC', 'MX',
            'NSA', 'NS', 'PTR', 'PX',
            'RP', 'SOA', 'SPF', 'SRV',
            'SSHFP', 'TXT'
          ].include? type
          raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][zone]

          response = Excon::Response.new
          response.status = 200

          if record_id = options['record_id']
            raise Fog::DNS::Dynect::NotFound unless record = zone[:records][type].find { |record| record[:record_id] == record_id.to_i }
            response.body = {
              "status" => "success",
              "data" => {
                "zone" => record[:zone][:zone],
                "ttl" => record[:ttl],
                "fqdn" => record[:fqdn],
                "record_type" => type,
                "rdata" => record[:rdata],
                "record_id" => record[:record_id]
              },
              "job_id" => Fog::Dynect::Mock.job_id,
              "msgs" => [{
                "INFO" => "get: Found the record",
                "SOURCE" => "API-B",
                "ERR_CD" => nil,
                "LVL" => "INFO"
              }]
            }
          else
            records = if type == "ANY"
                        zone[:records].values.flatten.select { |record| record[:fqdn] == fqdn }
                      else
                        zone[:records][type].select { |record| record[:fqdn] == fqdn }
                      end
            response.body = {
              "status" => "success",
              "data" => records.collect { |record| "/REST/#{record[:type]}Record/#{record[:zone][:zone]}/#{record[:fqdn]}/#{record[:record_id]}" },
              "job_id" => Fog::Dynect::Mock.job_id,
              "msgs" => [{
                "INFO" => "detail: Found #{records.size} record",
                "SOURCE" => "BLL",
                "ERR_CD" => nil,
                "LVL" => "INFO"
              }]
            }
          end

          response
        end
      end
    end
  end
end
