module Fog
  module HP
    class DNS

      class Real
        def update_record(domain_id, record_id, options)
          request(
            :body    => Fog::JSON.encode(options),
            :expects => 200,
            :method  => 'PUT',
            :path    => "domains/#{domain_id}/records/#{record_id}"
          )
        end

      end

      class Mock
        def update_record(domain_id, record_id, options)
          if record = find_record(domain_id, record_id)
            if options['name']
              domain['name'] = options['name']
            end
            response.status = 200
            response.body   = record
            response
          else
            raise Fog::HP::DNS::NotFound
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