module Fog
  module Identity
    class OpenStack
      class V3
        class Real
          def token_check(subject_token)
            request(
                :expects => [200, 204],
                :method => 'HEAD',
                :path => "auth/tokens",
                :headers => {"X-Subject-Token" => subject_token, "X-Auth-Token" => auth_token, }
            )
          end
        end

        class Mock
        end
      end
    end
  end
end