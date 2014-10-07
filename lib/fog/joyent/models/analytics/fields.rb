require 'fog/joyent/models/analytics/field'

module Fog
  module Joyent
    class Analytics
      class Fields < Fog::Collection
        model Fog::Joyent::Analytics::Field

        def all
          data = service.describe_analytics.body['fields']
          load(data)
        end

        # Joyent returns an odd data structure like this:
        # { 'apache' => {'label' => 'Apache'}}
        # where the key is the name of the module
        def new(attributes = {})
          name, other_attributes = attributes
          super(other_attributes.merge('name' => name))
        end
      end
    end
  end
end
