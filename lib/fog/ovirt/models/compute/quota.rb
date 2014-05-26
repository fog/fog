module Fog
  module Compute
    class Ovirt
      class Quota < Fog::Model
        identity :id

        attribute :name
        attribute :description

        def to_s
          name
        end
      end
    end
  end
end
