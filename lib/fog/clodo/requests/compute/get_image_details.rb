module Fog
	module Compute
		class Clodo
			class Real
				def get_image_details(image_id)
					request(:expects => [200,203],
					:method => 'GET',
					:path => "images/#{image_id}")
				end
			end
		end
	end
end
