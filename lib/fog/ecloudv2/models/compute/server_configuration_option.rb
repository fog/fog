module Fog
  module Compute
    class Ecloudv2
      class ServerConfigurationOption < Fog::Ecloudv2::Model
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
