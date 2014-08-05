module Fog
  module DNS
    class Dynect
      class Real
        # Update or replace a record
        #
        # ==== Parameters
        # * type<~String> - type of record in ['AAAA', 'ANY', 'A', 'CNAME', 'DHCID', 'DNAME', 'DNSKEY', 'DS', 'KEY', 'LOC', 'MX', 'NSA', 'NS', 'PTR', 'PX', 'RP', 'SOA', 'SPF', 'SRV', 'SSHFP', 'TXT']
        # * zone<~String> - zone of record
        # * rdata<~Hash> - rdata for record
        # * options<~Hash>: (options vary by type, listing below includes common parameters)
        #   * ttl<~Integer> - ttl for the record, defaults to zone ttl

        def put_record(type, zone, fqdn, rdata, options = {})
          options.merge!('rdata' => rdata)
          type.to_s.upcase!
          options = {"#{type}Records" => [options]} unless options['record_id']
          path = ["#{type}Record", zone, fqdn].join('/')
          path += "/#{options.delete('record_id')}" if options['record_id']
          request(
            :body       => Fog::JSON.encode(options),
            :expects    => 200,
            :idempotent => true,
            :method     => :put,
            :path       => path
          )
        end
      end

      class Mock
        def put_record(type, zone, fqdn, rdata, options = {})
          raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][zone]

          records = zone[:records]
          record_id = zone[:next_record_id]
          zone[:next_record_id] += 1

          record = {
            :type => type,
            :zone => zone,
            :fqdn => fqdn,
            :rdata => rdata,
            :ttl => options[:ttl] || zone[:ttl],
            :record_id => record_id
          }

          records[type] << record

          response = Excon::Response.new
          response.status = 200

          response.body = {
            "status" => "success",
            "data" => {
              "zone" => record[:zone][:zone],
              "ttl" => record[:ttl],
              "fqdn" => record[:fqdn],
              "record_type" => record[:type],
              "rdata" => record[:rdata],
              "record_id" => record[:record_id]
           },
           "job_id" => Fog::Dynect::Mock.job_id,
           "msgs" => [{
             "INFO"=>"add: Record added",
             "SOURCE"=>"BLL",
             "ERR_CD"=>nil,
             "LVL"=>"INFO"
           }]
          }

          response
        end
      end
    end
  end
end
