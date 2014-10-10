module Fog
  module Errors
    module Fogdocker
      class ServiceError < Fog::Errors::Error; end
      class AuthenticationError < ServiceError; end
    end
  end
end

