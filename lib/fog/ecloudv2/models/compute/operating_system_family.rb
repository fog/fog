module Fog
  module Compute
    class Ecloudv2
      class OperatingSystemFamily < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :operating_system_family, :aliases => :OperatingSystems

        def operating_systems
          @operating_systems ||= Fog::Compute::Ecloudv2::OperatingSystems.new(:connection => connection, :data => operating_system_family[:OperatingSystem])
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
