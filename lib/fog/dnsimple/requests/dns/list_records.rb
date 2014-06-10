module Fog
  module DNS
    class DNSimple
      class Real
        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * domain<~String> - domain name or numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * <~Array>:
        #       * 'record'<~Hash> The representation of the record.
        def list_records(domain)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/domains/#{domain}/records"
          )
        end
      end

      class Mock
        def list_records(domain)
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:records][domain] || []
          response
        end
      end
    end
  end
end
