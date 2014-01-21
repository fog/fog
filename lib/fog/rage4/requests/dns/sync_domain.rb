module Fog
  module DNS
    class Rage4
      class Real

        # Sync to external server ("Shadow Master")
        # You need to allow AXFR transfers
        # Only regular domains are supported
        # ==== Parameters
        # * name<~String> - domain name
        # * ip<~String> - Ip address of remote server
        # ==== Returns
        #
        #

        def sync_domain(name, ip)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/syncdomain/?name=#{name}&server=#{ip}"
          )
        end

      end


    end
  end
end
