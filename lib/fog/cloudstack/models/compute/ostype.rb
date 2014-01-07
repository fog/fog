module Fog
  module Compute
    class Cloudstack
      class Ostype < Fog::Model
        identity  :id,              :aliases => 'id'
        attribute :description,      :aliases => 'description'
        attribute :oscategoryid,       :aliases => 'oscategoryid'

      end # Ostype
    end # Cloudstack
  end # Compute
end # Fog