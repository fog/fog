module Fog
  module Volume
    class OpenStack
      
      class Real
        def list_limits
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'limits'
          )
        end
      end

      class Mock
        def list_limits
          rate_limits = [
          ]

          absolute_limits = {
            'maxTotalVolumeGigabytes' => 1000, 
            'maxTotalVolumes' => 10
          }

          Excon::Response.new(
            :status => 200,
            :body => {
              'limits' => {
                'rate'     => rate_limits,
                'absolute' => absolute_limits }
            }
          )
        end
      end

    end
  end
end