require 'fog/cloudsigma/nested_model'
require 'fog/cloudsigma/models/usage_record'

module Fog
  module Compute
    class CloudSigma
      class CurrentUsage < Fog::CloudSigma::CloudsigmaModel
        model_attribute :cpu, UsageRecord
        model_attribute :hdd, UsageRecord
        model_attribute :ip, UsageRecord
        model_attribute :mem, UsageRecord
        model_attribute :sms, UsageRecord
        model_attribute :ssd, UsageRecord
        model_attribute :tx, UsageRecord
        model_attribute :vlan, UsageRecord
      end
    end
  end
end
