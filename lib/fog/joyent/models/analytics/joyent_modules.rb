require 'fog/joyent/models/analytics/joyent_module'

module Fog
  module Joyent
    class Analytics
      class JoyentModules < Fog::Collection
        model Fog::Joyent::Analytics::JoyentModule

        def all
          data = service.describe_analytics.body['modules']
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
