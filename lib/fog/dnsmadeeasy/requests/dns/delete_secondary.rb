module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Deletes the specified secondary entry.
        #
        # ==== Parameters
        # * secondary_name<~String> - secondary domain name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> 200 - OK, 404 - specified secondary entry name is not found
        def delete_secondary(secondary_name)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/V1.2/secondary/#{secondary_name}"
          )
        end

      end
    end
  end
end
