module Fog
  module Dynect
    class DNS
      class Real

        require 'fog/dns/parsers/dynect/anyrecords'
        require 'fog/dns/parsers/dynect/anyrecord'

        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * domain<~String>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * records<Array~>
        #     * fqdn<~String>
        #     * address<~String>
        #     * record_type<~String>
        #     * ttl<~Integer>
        #     * zone<~String>
        def list_any_records(zone, fqdn)
          all_records = request(
                                :parser   => Fog::Parsers::Dynect::DNS::AnyRecords.new,
                                :expects  => [200, 307],
                                :method   => "GET",
                                :path     => "ANYRecord/#{zone}/#{fqdn}",
                                )

          all_records.body.inject([]) do |results, record|
            results << request(
                               :parser   => Fog::Parsers::Dynect::DNS::AnyRecord.new,
                               :expects  => [200, 307],
                               :method   => "GET",
                               :path     => "#{record['record_type']}Record/#{record['zone']}/#{record['fqdn']}/#{record['recordid']}",
                               )
            results
          end
        end
      end

      class Mock

        def list_any_records
          response = Excon::Response.new
          response.body = [{
                             "fqdn" => "example.com",
                             "address" => "127.0.0.1",
                             "zone" => "example.com",
                             "record_type" => "A",
                             "ttl" => 30
                           }]
          response
        end

      end

    end
  end
end
