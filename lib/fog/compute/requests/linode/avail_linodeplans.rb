module Fog
  module Linode
    class Compute
      class Real
        def avail_linodeplans(linodeplan_id = nil)
          options = {}
          if linodeplan_id
            options.merge!(:planId => linodeplan_id)
          end
          result = request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.linodeplans' }.merge!(options)
          )
          
          #hack for plans not filtering by id like they should above, remove when they fix it.
          result.body["DATA"] = result.body["DATA"].select { |item| item['PLANID'] == linodeplan_id } if linodeplan_id
          result
        end
      end
    end
  end
end
