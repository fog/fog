module Fog
  module Compute
    class Joyent
      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :os
        attribute :type
        attribute :version
        attribute :created, :type => :time
        attribute :default

      end
    end
  end
end
