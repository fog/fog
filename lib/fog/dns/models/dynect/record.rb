require 'fog/core/model'

module Fog
  module Dynect
    class DNS

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id,           :aliases => "record_id"
        attribute :name,        :aliases => "fqdn"
        attribute :value,       :aliases => "rdata"
        attribute :ttl
        attribute :zone_id,     :aliases => "zone"
        attribute :type,        :aliases => "record_type"

        def destroy
          raise 'destroy not implemented'
        end

        def save
          raise 'save not implemented'
        end
      end

    end
  end
end
