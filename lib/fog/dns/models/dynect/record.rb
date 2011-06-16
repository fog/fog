require 'fog/core/model'

module Fog
  module Dynect
    class DNS

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=

        identity :id
        attribute :name
        attribute :value,       :aliases => "content"
        attribute :ttl
        attribute :created_at
        attribute :updated_at
        attribute :zone_id,     :aliases => "domain_id"
        attribute :type,        :aliases => "record_type"
        attribute :priority,    :aliases => "prio"

        def initialize(attributes={})
        end

        def destroy
        end

        def zone
        end

        def save
        end

      end

    end
  end
end
