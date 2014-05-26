module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Returns a list of all secondary entry names for your account.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * list<~Array> e.g. ["xxx.domain.com", "xxx.domain.com"]
        #   * status<~Integer> 200 - OK
        def list_secondary
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => '/V1.2/secondary'
          )
        end
      end
    end
  end
end
