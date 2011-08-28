module Fog
  module DNS
    class DNSimple
      class Real

        # Delete the record with the given ID for the given domain.
        #
        # ==== Parameters
        # * domain<~String>
        # * record_id<~String>
        def delete_record(domain, record_id)

          request( :expects  => 200,
                   :method   => "DELETE",
                   :path     => "/domains/#{domain}/records/#{record_id}" )
        end

      end
    end
  end
end
