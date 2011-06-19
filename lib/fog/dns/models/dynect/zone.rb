require 'fog/core/model'
require 'fog/dns/models/dynect/records'

module Fog
  module Dynect
    class DNS

      class Zone < Fog::Model

        identity :id,           :aliases => "zone"
        attribute :serial
        attribute :zone_type
        attribute :serial_style

        def destroy
          raise 'destroy Not Implemented'
        end

        def records
          @records ||= Fog::Dynect::DNS::Records.new(:zone => self, :connection => connection)
        end

        def nameservers
          raise 'nameservers Not Implemented'
        end

        def save
          #raise 'Not Implemented'
          'dynect save'
        end

      end

    end
  end
end
