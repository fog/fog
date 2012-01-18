require 'fog/core/model'
require 'fog/dnsmadeeasy/models/dns/records'

module Fog
  module DNS
    class DNSMadeEasy

      class Zone < Fog::Model

        identity  :id
        attribute :domain,      :aliases => 'name'
        attribute :gtd_enabled, :aliases => 'gtdEnabled'
        attribute :nameservers, :aliases => 'nameServer'

        def destroy
          requires :identity
          connection.delete_domain(identity)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::DNSMadeEasy::Records.new(
              :zone       => self,
              :connection => connection
            )
          end
        end

        def save
          requires :domain
          data = connection.create_domain(domain).body
          self.identity = data['name']
          merge_attributes(data)
          true
        end

      end

    end
  end
end
