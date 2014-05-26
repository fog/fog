module Fog
  module Compute
    class Ecloud
      class OperatingSystem < Fog::Ecloud::Model
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
