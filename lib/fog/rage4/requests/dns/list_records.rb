module Fog
  module DNS
    class Rage4
      class Real
        # Get the list of records for the specific domain.
        #
        # ==== Parameters
        # * id<~Integer>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * records<Array~>
        #     * name<~String>
        #     * ttl<~Integer>
        #     * updated_at<~String>
        #     * domain_id<~Integer>
        #     * id<~Integer>
        #     * content<~String>
        #     * record_type<~String>
        #     * priority<~Integer>
        def list_records(id)
          request( :expects  => 200,
                   :method   => "GET",
                   :path     => "/rapi/getrecords/#{id}" )
        end
      end
    end
  end
end
