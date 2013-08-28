module Fog
  module Rackspace
    class AutoScale
      class Real
        def create_policy(group_id, options)
          
          data = [
            options
          ]

          request(
            :method => 'POST',
            :body => Fog::JSON.encode(data),
            :path => "groups/#{group_id}/policies",
            :expects => 201
          )
        end
      end

      class Mock
        def create_policy(group_id, options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
