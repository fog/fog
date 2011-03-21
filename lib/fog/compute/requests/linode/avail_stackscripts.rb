module Fog
  module Linode
    class Compute
      class Real
        def avail_stackscripts(options={})
          result = request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.stackscripts' }.merge!(options)
          )
          result.body['DATA']['DISTRIBUTIONIDLIST'] = result.body['DATA']['DISTRIBUTIONIDLIST'].to_s
          result
        end
      end
    end
  end
end
