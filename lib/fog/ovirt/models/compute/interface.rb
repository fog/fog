module Fog
  module Compute
    class Ovirt
      class Interface < Fog::Model
        attr_accessor :raw
        identity :id

        attribute :name
        attribute :network
        attribute :interface
        attribute :mac

        def to_s
          name
        end
      end
    end
  end
end
