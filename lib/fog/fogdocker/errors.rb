module Fog
  module Errors
    module Fogdocker
      class ServiceError < Fog::Errors::Error; end
      class AuthenticationError < Fog::Errors::Fogdocker::ServiceError; end
    end
  end
end

