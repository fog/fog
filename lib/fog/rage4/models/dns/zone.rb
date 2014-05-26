require 'fog/core/model'
require 'fog/rage4/models/dns/records'

module Fog
  module DNS
    class Rage4
      class Zone < Fog::Model
        identity :id

        attribute :domain,     :aliases => 'name'

        def destroy
          service.delete_domain(id)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::Rage4::Records.new(
              :zone    => self,
              :service => service
            )
          end
        end

        def nameservers
          [
           "ns1.r4ns.com",
           "ns2.r4ns.com",
          ]
        end

        def save
          requires :domain
          data = service.create_domain(domain).body["id"]
          merge_attributes(data)
          true
        end
      end
    end
  end
end
