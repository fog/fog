require 'fog/core/model'

module Fog
  module Compute
    class Clodo

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :vps_type
        attribute :status
        attribute :os_type
        attribute :os_bits
        attribute :os_hvm

        def initialize(new_attributes)
          super(new_attributes)
          merge_attributes(new_attributes['_attr']) if new_attributes['_attr']
        end

        def ready?
          status == 'ACTIVE'
        end

      end

    end
  end
end
