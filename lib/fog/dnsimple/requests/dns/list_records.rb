module Fog
  module DNS
    class DNSimple
      class Real

        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * domain<~String>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * records<Array~>
        #     * name<~String>
        #     * ttl<~Integer>
        #     * created_at<~String>
        #     * special_type<~String>
        #     * updated_at<~String>
        #     * domain_id<~Integer>
        #     * id<~Integer>
        #     * content<~String>
        #     * record_type<~String>
        #     * prio<~Integer>
        def list_records(domain)
          request( :expects  => 200,
                   :method   => "GET",
                   :path     => "/domains/#{domain}/records" )
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
