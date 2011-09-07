require 'fog/core/model'
require 'fog/bluebox/models/dns/records'

module Fog
  module DNS
    class Bluebox

      class Zone < Fog::Model

        identity :id

        attribute :domain,        :aliases => 'name'
        attribute :serial
        attribute :ttl
        attribute :retry
        attribute :expires
        attribute :record_count,  :aliases => 'record-count'
        attribute :refresh
        attribute :minimum

        def initialize(attributes = {})
          self.ttl ||= 3600
          super(attributes)
        end

        def destroy
          raise Fog::Errors::Error.new('Not implemented')
        end

        def records
          @records ||= begin
            Fog::DNS::Bluebox::Records.new(
              :zone       => self,
              :connection => connection
            )
          end
        end

        def nameservers
          [
            'ns1.blueblxgrid.com',
            'ns2.blueblxgrid.com',
            'ns3.blueblxgrid.com'
          ]
        end

        def destroy
          requires :identity
          connection.delete_zone(identity)
          true
        end

        def save
          requires :domain, :ttl
          options = attributes.dup
          options[:name] = options.delete(:domain)
          data = identity.nil? ? connection.create_zone(options) : connection.update_zone(identity, options)
          merge_attributes(data.body)
          true
        end
      end
    end
  end
end
