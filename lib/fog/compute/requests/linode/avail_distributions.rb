module Fog
  module Linode
    class Compute
      class Real
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
    end
  end
end
