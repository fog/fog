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

          result
        end
      end

      class Mock
        def avail_linodeplans(linodeplan_id = nil)
          response = Excon::Response.new
          response.status = 200
          body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.linodeplans"
          }
          if linodeplan_id
            mock_plan = create_mock_linodeplan(linodeplan_id)
            response.body = body.merge("DATA" => [mock_plan])
          else
            mock_plans = []
            10.times do
              plan_id = rand(1..99)
              mock_plans << create_mock_linodeplan(plan_id)
            end
            response.body = body.merge("DATA" => mock_plans)
          end
          response
        end

        private

        def create_mock_linodeplan(linodeplan_id)
          { "PRICE" => 19.95, "RAM" => 512, "XFER" => 200,
            "PLANID" => linodeplan_id, "LABEL" => "Linode #{linodeplan_id}",
            "DISK" => 20,
            "CORES" => 1,
            "AVAIL" => {
              "3"=>48, "2"=>207, "7"=>161, "6"=>143, "4"=>108, "8"=>60
            }
          }
        end
      end
    end
  end
end
