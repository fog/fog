require 'fog/core/model'
require 'fog/slicehost/models/dns/records'

module Fog
  module DNS
    class Slicehost

      class Zone < Fog::Model

        identity :id

        attribute :active
        attribute :domain, :aliases => 'origin'
        attribute :ttl

        def initialize(attributes={})
          self.active ||= true
          self.ttl    ||= 3600
          super
        end

        def active=(new_active)
          attributes[:active] = case new_active
          when false, 'N'
            false
          when true, 'Y'
            true
          end
        end

        def destroy
          requires :identity
          connection.delete_zone(identity)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::Slicehost::Records.new(
              :zone       => self,
              :connection => connection
            )
          end
        end

        def nameservers
          [
            'ns1.slicehost.net',
            'ns2.slicehost.net',
            'ns3.slicehost.net'
          ]
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :active, :domain, :ttl
          options = {}
          options[:active]  = active ? 'Y' : 'N'
          options[:ttl]     = ttl
          data = connection.create_zone(domain, options)
          merge_attributes(data.body)
          true
        end

      end

    end
  end
end
