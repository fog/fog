module Fog
  module Compute
    class Linode
      class Real

        # Get available plans
        #
        # ==== Parameters
        # * linodeplanId<~Integer>: id to limit results to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs        
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
