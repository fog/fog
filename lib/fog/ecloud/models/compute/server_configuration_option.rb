module Fog
  module Compute
    class Ecloud
      class ServerConfigurationOption < Fog::Ecloud::Model
        identity :href

        attribute :disk, :aliases => :Disk
        attribute :customization, :aliases => :Customization

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
