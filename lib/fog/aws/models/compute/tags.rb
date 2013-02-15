require 'fog/core/collection'
require 'fog/aws/models/compute/tag'

module Fog
  module Compute
    class AWS

      class Tags < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::Tag

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.describe_tags(filters).body
          load(data['tagSet'])
        end

        def get(key)
          if key
            self.class.new(:service => service).all('key' => key)
          end
        end
      end

    end
  end
end
