module Fog
  module HP
    class DNS
      class Real
        # Create a new DNS record
        #
        # ==== Parameters
        # * 'domain_id'<~String> - UUId of the domain
        # * 'name'<~String> - Name of record
        # * 'type'<~String> - Type of the record i.e. 'A'
        # * 'data'<~String> - Data required by the record
        # * options<~Hash>:
        #   * 'description'<~String> - Description for the record
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
        def create_record(domain_id, name, type, data, options={})
          data = {
              :name => name,
              :type => type,
              :data => data
          }
          l_options = [:description, :priority, :ttl]
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          request(
              :body    => Fog::JSON.encode(data),
              :expects => 200,
              :method  => 'POST',
              :path    => "domains/#{domain_id}/records"
          )
        end
      end
      class Mock
        def create_record(domain_id, name, type, data, options={})
          response        = Excon::Response.new
          if list_domains.body['domains'].find {|_| _['id'] == domain_id}
            response.status = 200
            data = {
                'id'           => Fog::HP::Mock.uuid.to_s,
                'domain_id'    => domain_id,
                'name'         => name || 'www.example.com.',
                'type'         => type || 'A',
                'data'         => data || '15.185.172.152',
                'ttl'          => options['ttl'] || 3600,
                'description'  => options['description'] || 'desc for www.example.com.',
                'priority'     => options['priority'] || nil,
                'created_at'   => '2012-11-02T19:56:26.366792',
                'updated_at'   => '2012-11-02T19:56:26.366792'
            }
            self.data[:records][data['id']] = data
            response.body = data
            response
          else
            raise Fog::HP::DNS::NotFound
          end
        end
      end
    end
  end
end
