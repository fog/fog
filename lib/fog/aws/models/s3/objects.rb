module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attr_accessor :is_truncated, :marker, :max_keys, :prefix

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'IsTruncated' => :is_truncated,
            'Marker' => :marker,
            'MaxKeys' => :max_keys,
            'Prefix' => :prefix
          })
          super
        end

      end

    end
  end
end
