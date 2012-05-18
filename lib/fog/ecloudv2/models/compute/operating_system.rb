module Fog
  module Compute
    class Ecloudv2
      class OperatingSystem < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
