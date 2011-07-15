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
            :method   => :get,
            :path     => ["#{type.to_s.upcase}Record", zone, fqdn, options['record_id']].compact.join('/')
          )
        end
      end
    end
  end
end
