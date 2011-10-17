module Fog
  module DNS
    class DNSimple
      class Real

        # Update the given record for the given domain.
        #
        # ==== Parameters
        # * domain<~String>
        # * record_id<~String>
        # * options<~Hash> - optional
        #   * type<~String>
        #   * content<~String>
        #   * priority<~Integer>
        #   * ttl<~Integer>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * record<~Hash>
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
        def update_record(domain, record_id, options)

          body = { "record" => options }

          request( :body     => MultiJson.encode(body),
                   :expects  => 200,
                   :method   => "PUT",
                   :path     => "/domains/#{domain}/records/#{record_id}" )
        end

      end
    end
  end
end
