module Fog
  module Compute
    class Vsphere
      class Template < Fog::Model
        identity :id
        attribute :name
        attribute :uuid
      end
    end
  end
end
