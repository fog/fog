module Fog
  module Compute
    class Ecloudv2
      class HardwareConfiguration < Fog::Model
        identity :href

        attribute :processor_count, :aliases => :ProcessorCount, :type => :integer
        attribute :mem, :aliases => :Memory
        attribute :storage, :aliases => :Disks
        attribute :network_cards, :aliases => :Nics

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
