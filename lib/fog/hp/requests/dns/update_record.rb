module Fog
  module HP
    class DNS
      class Real
        # Update an existing DNS record
        #
        # ==== Parameters
        # * 'domain_id'<~String> - UUId of domain of record
        # * 'record_id'<~String> - UUId of record to update
        # * options<~Hash>:
        #   * 'name'<~String> - Name of record
        #   * 'description'<~String> - Description for the record
        #   * 'type'<~String> - Type of the record i.e. 'A'
        #   * 'data'<~String> - Data required by the record
        #   * 'priority'<~Integer> - Priority
        #   * 'ttl'<~Integer> - TTL of the record
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~String> - UUID of the record
        #     * 'name'<~String> - Name of the record
        #     * 'description'<~String> - Description for the record
        #     * 'type'<~String> - Type of the record
        #     * 'domain_id'<~String> - UUID of the domain
        #     * 'ttl'<~Integer> - TTL of the record
        #     * 'data'<~String> - Data required by the record
        #     * 'priority'<~Integer> - Priority for the record
        #     * 'created_at'<~String> - created date time stamp
        #     * 'updated_at'<~String> - updated date time stamp
        def update_record(domain_id, record_id, options={})
          data = {}
          l_options = [:name, :description, :type, :data, :priority, :ttl]
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          request(
            :body    => Fog::JSON.encode(data),
            :expects => 200,
            :method  => 'PUT',
            :path    => "domains/#{domain_id}/records/#{record_id}"
          )
        end
      end

      class Mock
        def update_record(domain_id, record_id, options)
          response = Excon::Response.new
          if record = list_records_in_a_domain(domain_id).body['records'].find { |_| _['id'] == record_id }
            record['name']      = options[:name]      if options[:name]
            record['type']      = options[:type]      if options[:type]
            record['data']      = options[:data]      if options[:data]
            record['priority']  = options[:priority]  if options[:priority]

            response.status = 200
            response.body   = record
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end
