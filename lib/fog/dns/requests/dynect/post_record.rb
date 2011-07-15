module Fog
  module DNS
    class Dynect
      class Real

        # Create a record
        #
        # ==== Parameters
        # * type<~String> - type of record in ['AAAA', 'ANY', 'A', 'CNAME', 'DHCID', 'DNAME', 'DNSKEY', 'DS', 'KEY', 'LOC', 'MX', 'NSA', 'NS', 'PTR', 'PX', 'RP', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TXT']
        # * zone<~String> - zone of record
        # * rdata<~Hash> - rdata for record
        # * options<~Hash>: (options vary by type, listing below includes common parameters)
        #   * ttl<~Integer> - ttl for the record, defaults to zone ttl

        def post_record(type, zone, fqdn, rdata, options = {})
          options.merge!('rdata' => rdata)
          request(
            :body     => MultiJson.encode(options),
            :expects  => 200,
            :method   => :post,
            :path     => ["#{type.to_s.upcase}Record", zone, fqdn].join('/')
          )
        end
      end
    end
  end
end
