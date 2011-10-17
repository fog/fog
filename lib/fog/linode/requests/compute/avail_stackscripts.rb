module Fog
  module Compute
    class Linode
      class Real

        def avail_stackscripts(options={})
          result = request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.stackscripts' }.merge!(options)
          )
          result.body['DATA'].each { |r| r['DISTRIBUTIONIDLIST'] = r['DISTRIBUTIONIDLIST'].to_s }
          result
        end

      end
    end
  end
end
