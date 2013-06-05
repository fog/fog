module Fog
  module HP
    class DNS
      class Real
        def get_record(domain_id, record_id)
          response = request(
              :expects => 200,
              :method  => 'GET',
              :path    => "domains/#{domain_id}/records/#{record_id}"
          )
          response
        end
      end
      class Mock
        def get_record(domain_id, record_id)
          if record = find_record(domain_id, record_id)
            response.status = 200
            response.body   = record
            response
          else
            response.status = 400
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
