module Fog
  module Compute
    class Ecloud
      class HardwareConfiguration < Fog::Ecloud::Model
        identity :href

        attribute :processor_count, :aliases => :ProcessorCount,           :type => :integer
        attribute :memory,          :aliases => :Memory, :squash => :Value # {:Memory => {:Value => 15}}
        attribute :storage,         :aliases => :Disks,  :squash => :Disk
        attribute :network_cards,   :aliases => :Nics,   :squash => :Nic

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
