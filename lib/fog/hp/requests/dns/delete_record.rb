module Fog
  module HP
    class DNS
      class Real
        # Delete a DNS Record
        #
        # ==== Parameters
        # * 'domain_id'<~String> - UUId of domain for record
        # * 'record_id'<~String> - UUId of record to delete
        #
        def delete_record(domain_id, record_id)
          request(
              :expects => 200,
              :method  => 'DELETE',
              :path    => "domains/#{domain_id}/records/#{record_id}"
          )
        end
      end

      class Mock
        def delete_record(domain_id, record_id)
          response = Excon::Response.new
          if list_records_in_a_domain(domain_id).body['records'].find { |_| _['id'] == record_id }
            response.status = 200
            response
          else
            raise Fog::HP::DNS::NotFound
          end
          response
        end
      end
    end
  end
end
