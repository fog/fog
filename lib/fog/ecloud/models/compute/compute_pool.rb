module Fog
  module Compute
    class Ecloud
      class ComputePool < Fog::Ecloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :id, :aliases => :Id
        attribute :href, :aliases => :Href
        attribute :state, :aliases => :State
        attribute :is_default, :aliases => :IsDefault
        
      end
    end
  end
end
