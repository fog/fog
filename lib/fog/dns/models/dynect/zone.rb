require 'fog/core/model'
require 'fog/dns/models/dynect/records'

module Fog
  module Dynect
    class DNS

      class Zone < Fog::Model

        identity :zone
        attribute :serial
        attribute :zone_type
        attribute :serial_style

        def destroy
          raise 'Not Implemented'
        end

        def records
          raise 'Not Implemented'
        end

        def nameservers
          raise 'Not Implemented'
        end

        def save
          raise 'Not Implemented'
        end

      end

    end
  end
end
