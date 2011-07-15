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
            :method   => :delete,
            :path     => ["#{type.to_s.upcase}Record", zone, fqdn, record_id].join('/')
          )
        end
      end
    end
  end
end
