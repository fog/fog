module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_internet_service
      end

      class Mock
        def get_internet_service(uri)
          internet_service_id = id_from_uri(uri)
          internet_service    = self.data[:internet_services][internet_service_id.to_i]

          if internet_service
            response(:body => Fog::Ecloud.slice(internet_service, :id, :public_ip))
          else raise Fog::Errors::NotFound
          end
        end
      end
    end
  end
end
