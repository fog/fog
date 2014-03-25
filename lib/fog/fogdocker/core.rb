require 'fog/core'

module Fog
  module Fogdocker

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'Compute')

  end
end