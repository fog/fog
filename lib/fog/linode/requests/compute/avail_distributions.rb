module Fog
  module Compute
    class Linode
      class Real
        # Get available distributions
        #
        # ==== Parameters
        # * distributionId<~Integer>: id to limit results to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def avail_distributions(distribution_id=nil)
          options = {}
          if distribution_id
            options.merge!(:distributionId => distribution_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.distributions' }.merge!(options)
          )
        end
      end

      class Mock
        def avail_distributions(distribution_id=nil)
          response = Excon::Response.new
          response.status = 200

          body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.distributions"
          }
          if distribution_id
            mock_distribution = create_mock_distribution(distribution_id)
            response.body = body.merge("DATA" => [mock_distribution])
          else
            mock_distributions = []
            10.times do
              distribution_id = rand(1..99)
              mock_distributions << create_mock_distribution(distribution_id)
            end
            response.body = body.merge("DATA" => mock_distributions)
          end
          response
        end

        private

        def create_mock_distribution(distribution_id)
          {
            "CREATE_DT"           => "2012-04-26 17:25:16.0",
            "DISTRIBUTIONID"      => distribution_id,
            "IS64BIT"             => 0,
            "LABEL"               => "Ubuntu 12.04 LTS",
            "MINIMAGESIZE"        => 600,
            "REQUIRESPVOPSKERNEL" => 1
          }
        end
      end
    end
  end
end
