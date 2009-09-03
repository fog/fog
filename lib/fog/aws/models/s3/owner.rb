module Fog
  module AWS
    class S3

      class Owner < Fog::Model

        attribute :display_name,  'DisplayName'
        attribute :id,            'ID'

        def initialize(attributes = {})
          super
        end

      end

    end
  end
end
