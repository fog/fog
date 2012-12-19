module Fog
  module Compute
    class Ovirt

      class Host < Fog::Model

        identity :id

        attribute :name
        attribute :address
        attribute :raw
        attribute :description
        attribute :status

        def to_s
          name
        end

      end

    end
  end
end
