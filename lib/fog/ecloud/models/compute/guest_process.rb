module Fog
  module Compute
    class Ecloud
      class GuestProcess < Fog::Ecloud::Model
        identity :name

        attribute :process_id, :aliases => :ProcessId

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
