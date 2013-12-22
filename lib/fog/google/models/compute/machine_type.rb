module Fog
  module Compute
    class Google
      class MachineType < Fog::Model

        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :id, :aliases => 'id'
        


      end
    end
  end
end
