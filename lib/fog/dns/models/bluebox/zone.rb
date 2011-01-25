require 'fog/core/model'
require 'fog/dns/models/bluebox/records'

module Fog
  module Bluebox
    class DNS

      class Zone < Fog::Model

        identity :id

        attribute :name
        attribute :serial
        attribute :ttl
        attribute :retry
        attribute :expires
        attribute :record_count, :aliases => 'record-count'
        attribute :refresh
        attribute :minimum

        def initialize(attributes = {})
          super(attributes)
        end

        def destroy
          raise Fog::Errors::Error.new('Not implemented')
        end

        def records
          @records ||= begin
            Fog::Bluebox::DNS::Records.new(
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

        def save
          raise Fog::Errors::Error.new('Not implemented')
        end

      end

    end
  end
end
