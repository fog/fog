module Fog
  module Compute
    class Ecloudv2
      class ServerConfigurationOption < Fog::Model
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
