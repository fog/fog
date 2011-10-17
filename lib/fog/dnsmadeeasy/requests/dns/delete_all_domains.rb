module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Deletes all domains for your account.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * status<~Integer> - 200 - OK
        def delete_all_domains
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => '/V1.2/domains'
          )
        end

      end
    end
  end
end
