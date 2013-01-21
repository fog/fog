require 'fog/core/model'
require 'fog/dreamhost/models/dns/records'

module Fog
  module DNS
    class Dreamhost 

      #
      # Dreamhost API has no concept of 'Zone', but we
      # can emulate it.
      #
      # http://wiki.dreamhost.com/API/Dns_commands
      #
      class Zone < Fog::Model

        identity :id
        attribute :domain,     :aliases => 'name'

        # 
        # There's no destroy API call
        #
        def destroy
          raise NotImplementedError.new
        end

        #
        # Return a list of records for this zone
        #
        def records
          @records ||= begin
            Fog::DNS::Dreamhost::Records.new( :zone => self, :service => service )
          end
        end

        #
        # Return the Dreamhost nameserver list
        #
        def nameservers
          [
           "ns1.dreamhost.com",
           "ns2.dreamhost.com",
           "ns3.dreamhost.com",
          ]
        end

        # 
        # There's no zone create API call
        #
        def save
          raise NotImplementedError.new
        end

      end

    end
  end
end
