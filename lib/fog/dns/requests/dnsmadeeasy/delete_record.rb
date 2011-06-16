module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Deletes the record with the specified id. Note that records are not modifiable for domains that are locked to a template.
        #
        # ==== Parameters
        # * domain<~String> - domain name
        # * record_id<~String> - record id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> 200 - OK, 404 - specified domain name or record id is not found
        def delete_record(domain, record_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/V1.2/domains/#{domain}/records/#{record_id}"
          )
        end

      end
    end
  end
end
