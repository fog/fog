require 'fog/core/model'
require 'fog/dnsimple/models/dns/records'

module Fog
  module DNS
    class DNSimple
      class Zone < Fog::Model
        identity :id

        attribute :domain,     :aliases => 'name'
        attribute :created_at
        attribute :updated_at

        def destroy
          service.delete_domain(identity)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::DNSimple::Records.new(
              :zone       => self,
              :service => service
            )
          end
        end

        def nameservers
          [
           "ns1.dnsimple.com",
           "ns2.dnsimple.com",
           "ns3.dnsimple.com",
           "ns4.dnsimple.com",
          ]
        end

        def save
          requires :domain
          data = service.create_domain(domain).body["domain"]
          merge_attributes(data)
          true
        end
      end
    end
  end
end
