require 'fog/core'

module Fog
  module Tutum
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
      class Execution < ServiceError; end
    end

    service(:compute, 'Compute')
  end
end
