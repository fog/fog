module Fog
  module Network
    class OpenStack
      class Real
        def meter_label_create( name, tenant_id )
          data = {
            metering_label: {
              name: name,
              tenant_id: tenant_id
            }
          }

          request(
            body:       Fog::JSON.encode( data ),
            expects:    [ 201 ],
            method:     'POST',
            path:       "metering/metering-labels.json"
          )
        end
      end
    end
  end
end
