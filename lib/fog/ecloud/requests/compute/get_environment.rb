module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_environment
      end

      class Mock
        def get_environment(uri)
          environment_id = id_from_uri(uri)
          organizations = self.data[:organizations].values
          environment = nil
          catch(:found) do
            organizations.each do |organization|
              organization[:Locations][:Location].each do |location|
                environment = location[:Environments][:Environment].find{|e| e[:id] == environment_id}
                throw :found if environment
              end
            end
          end
          if environment
            body = environment.dup
            body.delete(:id)
            response(:body => body)
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
