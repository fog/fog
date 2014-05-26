module Fog
  module Compute
    class Ecloud
      class PhysicalDevice < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :tags, :aliases => :Tags
        attribute :layout, :aliases => :Layout
        attribute :network_host, :aliases => :NetworkHost
        attribute :classification, :aliases => :Classification
        attribute :model, :aliases => :Model

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
