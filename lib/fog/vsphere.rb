require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Vsphere

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'vsphere/compute', 'Compute')
    service(:storage, 'vsphere/storage', 'Storage')
    service(:highavailablity, 'vsphere/highavailability', 'Highavailability')


  end

end
