require 'fog/core'
require 'fog/xml'

module Fog
  module Ovirt
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'Compute')
  end
end
