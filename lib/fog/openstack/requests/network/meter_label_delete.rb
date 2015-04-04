module Fog
  module Network
    class OpenStack
      class Real
        def meter_label_delete( label_id )
          request(
            expects:    [ 204 ],
            method:     'DELETE',
            path:       "metering/metering-labels/#{label_id}.json"
          )
        end
      end
    end
  end
end
