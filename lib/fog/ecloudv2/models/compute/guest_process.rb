module Fog
  module Compute
    class Ecloudv2
      class GuestProcess < Fog::Ecloudv2::Model
        identity :name

        attribute :process_id, :aliases => :ProcessId
        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
