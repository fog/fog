module Fog
  module Volume
    class OpenStack
      # no Mock needed, test coverage in RSpec

      class Real
        def delete_transfer(transfer_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "os-volume-transfer/#{transfer_id}"
          )
        end
      end
    end
  end
end
