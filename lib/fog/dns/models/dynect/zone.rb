require 'fog/core/model'
require 'fog/dns/models/dynect/records'

module Fog
  module Dynect
    class DNS

      class Zone < Fog::Model

        identity :id

        attribute :domain,     :aliases => 'name'
        attribute :created_at
        attribute :updated_at

        def destroy
        end

        def records
        end

        def nameservers
        end

        def save
        end

      end

    end
  end
end
