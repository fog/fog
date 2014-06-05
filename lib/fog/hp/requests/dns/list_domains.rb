module Fog
  module HP
    class DNS
      class Real
        # List all DNS domains
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'domains'<~Array>:
      #       * 'id'<~String> - UUID of the domain
      #       * 'name'<~String> - Name of the domain
      #       * 'ttl'<~Integer> - TTL for the domain
      #       * 'email'<~String> - Email for the domain
      #       * 'serial'<~Integer> - Serial number for the domain
      #       * 'created_at'<~String> - created date time stamp
        def list_domains
          request(
              :expects => 200,
              :method  => 'GET',
              :path    => 'domains'
          )
        end
      end

      class Mock
        def list_domains
          response        = Excon::Response.new
          domains = self.data[:domains].values
          response.status = 200
          response.body = { 'domains' => domains }
          response
        end
      end
    end
  end
end
