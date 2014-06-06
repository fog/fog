module Fog
  module Compute
    class Joyent
      class Flavor < Fog::Model
        identity :id

        attribute :name
        attribute :memory
        attribute :swap
        attribute :disk
        attribute :vcpus
        attribute :default, :type => :boolean
        attribute :description
        attribute :version
        attribute :group
      end
    end
  end
end
