module Fog
  module Network
    class OpenStack
      class Real
        def meter_label_rule_create( label_id, cidr, direction, excluded = false )
          data = {
            metering_label_rule: {
              metering_label_id: label_id,
              remote_ip_prefix: cidr,
              direction: direction,
              excluded: excluded
            }
          }

          request(
            body:       Fog::JSON.encode( data ),
            expects:    [ 201 ],
            method:     'POST',
            path:       "metering/metering-label-rules.json"
          )
        end
      end
    end
  end
end
