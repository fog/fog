module Fog
  module Rackspace
    class AutoScale
      class Real

        def create_group
          request(
            :expects => [201],
            :method => 'POST',
            :path => 'groups',
            :body => <<-JSON
             {
                  \"groupConfiguration\": {
                      \"name\": \"workers2\",
                      \"cooldown\": 60,
                      \"minEntities\": 5,
                      \"maxEntities\": 25,
                      \"metadata\": {
                          \"firstkey\": \"this is a string\",
                          \"secondkey\": \"1\"
                      }
                  },
                  \"launchConfiguration\": {
                      \"type\": \"launch_server\",
                      \"args\": {
                          \"server\": {
                              \"flavorRef\": 3,
                              \"name\": \"webhead\",
                              \"imageRef\": \"0d589460-f177-4b0f-81c1-8ab8903ac7d8\",
                              \"OS-DCF:diskConfig\": \"AUTO\",
                              \"metadata\": {
                                  \"mykey\": \"myvalue\"
                              },
                              \"personality\": [
                                  {
                                      \"path\": \"/root/.ssh/authorized_keys\",
                                      \"contents\": \"ssh-rsa AAAAB3Nza...LiPk== user@example.net\"
                                  }
                              ],
                              \"networks\": [
                                  {
                                      \"uuid\": \"11111111-1111-1111-1111-111111111111\"
                                  }
                              ]
                          },
                          \"loadBalancers\": [
                              {
                                  \"loadBalancerId\": 2200,
                                  \"port\": 8081
                              }
                          ]
                      }
                  },
                  \"scalingPolicies\": [
                      {
                          \"name\": \"scale up by 10\",
                          \"change\": 10,
                          \"cooldown\": 5,
                          \"type\": \"webhook\"
                      },
                      {
                          \"name\": \"scale down by 5.5 percent\",
                          \"changePercent\": -5.5,
                          \"cooldown\": 6,
                          \"type\": \"webhook\"
                      },
                      {
                          \"name\": \"set number of servers to 10\",
                          \"desiredCapacity\": 10,
                          \"cooldown\": 3,
                          \"type\": \"webhook\"
                      }
                  ]
              }
            JSON
          )
        end
      end

      class Mock
        def create_group
          Fog::Mock.not_implemented

        end
      end
    end
  end
end
