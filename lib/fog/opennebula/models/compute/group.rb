require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula
      class Group < Fog::Model

        identity :id
        attribute :name

        def save
          raise Fog::Errors::Error.new('Creating a new group is not yet implemented. Contributions welcome!')
        end

        def to_label
          name
        end

      end
    end
  end
end
