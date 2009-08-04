module Fog
  module AWS
    class S3

      class Owner < Fog::Model

        attr_accessor :display_name, :id

        def initialize(attributes = {})
          remap_attributes(attributes, { 
            'DisplayName' => :display_name,
            'ID'          => :id
          })
          super
        end

      end

    end
  end
end
