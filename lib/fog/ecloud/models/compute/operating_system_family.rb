module Fog
  module Compute
    class Ecloud
      class OperatingSystemFamily < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :operating_system_family, :aliases => :OperatingSystems

        def operating_systems
          @operating_systems ||= Fog::Compute::Ecloud::OperatingSystems.new(:connection => connection, :data => operating_system_family[:OperatingSystem])
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
