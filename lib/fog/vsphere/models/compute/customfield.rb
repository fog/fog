module Fog
  module Compute
    class Vsphere
      class Customfield < Fog::Model
        identity :key

        attribute :name
        attribute :type

        def to_s
          name
        end
      end
    end
  end
end
