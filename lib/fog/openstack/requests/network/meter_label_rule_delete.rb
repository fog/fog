module Fog
  module Network
    class OpenStack
      class Real
        def meter_label_rule_delete( rule_id )
          request(
            :expects =>  [ 204 ],
            :method =>   'DELETE',
            :path =>     "metering/metering-label-rules/#{rule_id}.json"
          )
        end
      end

      class Mock
        def meter_label_rule_delete( rule_id )
          response = Excon::Response.new
	  response.status = 204
	  response
	end
      end
    end
  end
end
