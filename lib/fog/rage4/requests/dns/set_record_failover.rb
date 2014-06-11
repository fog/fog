module Fog
  module DNS
    class Rage4
      class Real
        # Set a failover to on or off
        # ==== Parameters
        # * id<~Integer> - numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def set_record_failover(id, active, failover)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/setrecordfailover/#{id}&active=#{active}&failover=#{failover}"
            )
        end
      end
    end
  end
end
