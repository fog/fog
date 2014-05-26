module Fog
  module HP
    class DNS
      class Real
        # List DNS records for a given domain
        #
        # ==== Parameters
        # * 'domain_id'<~String> - UUId of domain for record
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'records'<~Array>:
        #       * 'id'<~String> - UUID of the record
        #       * 'name'<~String> - Name of the record
        #       * 'description'<~String> - Description for the record
        #       * 'type'<~String> - Type of the record
        #       * 'domain_id'<~String> - UUID of the domain
        #       * 'ttl'<~Integer> - TTL of the record
        #       * 'data'<~String> - Data required by the record
        #       * 'priority'<~Integer> - Priority for the record
        #       * 'created_at'<~String> - created date time stamp
        #       * 'updated_at'<~String> - updated date time stamp
        def list_records_in_a_domain(domain_id)
          request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{domain_id}/records"
          )
        end
      end
      class Mock
        def list_records_in_a_domain(domain_id)
          response = Excon::Response.new
          if domain = list_domains.body['domains'].find { |_| _['id'] == domain_id }
            response.status = 200
            response.body = { 'records' => records_for_domain(domain_id) }
          else
            raise Fog::HP::DNS::NotFound
          end
          response
        end

        def records_for_domain(domain_id)
          rdata = data[:records].select { |_,v| v['domain_id'] == domain_id}
          records = []
          rdata.each { |_,v| records << v }
          records
        end
      end
    end
  end
end
