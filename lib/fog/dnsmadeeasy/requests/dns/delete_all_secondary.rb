module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Deletes all secondary entries for your account.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> 200 - OK
        def delete_all_secondary
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => '/#{@api_version}/secondary'
          )
        end
      end
    end
  end
end
