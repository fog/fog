require 'fog/core/model'
require 'fog/dns/models/dnsmadeeasy/records'

module Fog
  module DNSMadeEasy
    class DNS

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
            Fog::DNSMadeEasy::DNS::Records.new(
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
