require 'fog/core/model'
require 'fog/dynect/models/dns/records'

module Fog
  module DNS
    class Dynect

      class Zone < Fog::Model

        identity  :domain

        attribute :domain,        :aliases => 'zone'
        attribute :email,         :aliases => 'rname'
        attribute :serial
        attribute :serial_style
        attribute :ttl
        attribute :type,          :aliases => 'zone_type'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :domain
          service.delete_zone(domain)
          true
        end

        undef_method :domain=
        def domain=(new_domain)
          attributes[:domain] = new_domain.split('/').last
        end

        def publish
          requires :identity
          data = service.put_zone(identity, 'publish' => true)
          true
        end

        def records
          @records ||= Fog::DNS::Dynect::Records.new(:zone => self, :service => service)
        end

        def nameservers
          raise 'nameservers Not Implemented'
        end

        def save
          self.ttl ||= 3600
          requires :domain, :email, :ttl
          data = service.post_zone(email, ttl, domain).body['data']
          merge_attributes(data)
          true
        end

      end

    end
  end
end
