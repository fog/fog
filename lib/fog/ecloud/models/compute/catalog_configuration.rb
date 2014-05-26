module Fog
  module Compute
    class Ecloud
      class CatalogConfiguration < Fog::Ecloud::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :processor_count, :aliases => :ProcessorCount, :type => :integer
        attribute :memory, :aliases => :Memory
        attribute :operating_system, :aliases => :OperatingSystem
        attribute :disks, :aliases => :Disks
        attribute :network_adapters, :aliases => :NetworkAdapters, :type => :integer
        attribute :network_mappings, :aliases => :NetworkMappings

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
