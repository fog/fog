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

      class Mock
        def meter_label_create( name, tenant_id )
	  response = Excon::Response.new
	  response.status = 201

	  data = {
	    metering_label: {
              shared: false,
	      description: '',
	      tenant_id: tenant_id,
	      name: name,
	      id: Fog::Mock.random_numbers( 6 ).to_s
	    }
	  }

	  # TODO, maybe
	  # self.data[:meters][data['metering_label'][:id]] = data['metering_label']
	  response.body = data
	  response
        end
      end
    end
  end
end
