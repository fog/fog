module Fog
  module HP
    class DNS
      class Real
        # Get details of an existing DNS record
        #
        # ==== Parameters
        # * 'domain_id'<~String> - UUId of domain for record
        # * 'record_id'<~String> - UUId of record to get
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUID of the record
        #     * 'name'<~String> - Name of the record
        #     * 'description'<~String> - Description for the record
        #     * 'type'<~String> - Type of the record
        #     * 'domain_id'<~String> - UUId of the domain
        #     * 'ttl'<~Integer> - TTL of the record
        #     * 'data'<~String> - Data required by the record
        #     * 'priority'<~Integer> - Priority for the record
        #     * 'created_at'<~String> - created date time stamp
        #     * 'updated_at'<~String> - updated date time stamp
        def get_record(domain_id, record_id)
          request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{domain_id}/records/#{record_id}"
          )
        end
      end
      class Mock
        def get_record(domain_id, record_id)
          response = Excon::Response.new
          if record = list_records_in_a_domain(domain_id).body['records'].find { |_| _['id'] == record_id }
            response.status = 200
            response.body = record
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end
