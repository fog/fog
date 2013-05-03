module Fog
  module HP
    class DNS
      class Real
        # Delete a Record
        #
        # ==== Parameters
        # * domain_id<~Integer> - Id of domain for record
        # * record_id<~Integer> - Id of record to delete
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
          if image = find_record(domain_id, record_id)
            response.status = 200
            response
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

        def find_record(domain_id, record_id)
          list_records_in_a_domain(domain_id).body['records'].detect { |_| _['id'] == record_id }
        end
      end

    end
  end
end