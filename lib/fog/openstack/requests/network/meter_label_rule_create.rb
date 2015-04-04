module Fog
  module Network
    class OpenStack
      class Real
        def meter_label_rule_create( label_id, cidr, direction, excluded = false )
          data = {
            'metering_label_rule' => {
              'metering_label_id' => label_id,
              'remote_ip_prefix' => cidr,
              'direction' => direction,
              'excluded' => excluded
            }
          }

          request(
            :body =>     Fog::JSON.encode( data ),
            :expects =>  [ 201 ],
            :method =>   'POST',
            :path =>     "metering/metering-label-rules.json"
          )
        end
      end

      class Mock
        def meter_label_rule_create( label_id, cidr, direction, excluded = false )
	  response = Excon::Response.new
	  response.status = 201

	  data = {
	    'metering_label_rule' => {
	      :id => Fog::Mock.random_numbers( 6 ).to_s,
	      :remote_ip_prefix => cidr,
	      :direction => direction,
	      :metering_label_id => label_id,
	      :excluded => excluded
	    }
	  }

	  # TODO, maybe
	  # self.data[:meters][data['metering_label_rule'][:metering_label_id]] = data['metering_label_rule']
	  response.body = data
	  response
        end
      end
    end
  end
end
