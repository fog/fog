module Fog
  module Compute
    class Cloudstack
      class DiskOffering < Fog::Model
        identity  :id
        attribute :name

      end
    end
  end
end