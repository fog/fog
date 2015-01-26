require 'fog/core/collection'
require 'fog/cloudsigma/models/fwpolicy'

module Fog
  module Compute
    class CloudSigma
      class Fwpolicies < Fog::Collection
        model Fog::Compute::CloudSigma::FWPolicy

        def all
          resp = service.list_fwpolicies
          data = resp.body['objects']
          load(data)
        end
      end
    end
  end
end
