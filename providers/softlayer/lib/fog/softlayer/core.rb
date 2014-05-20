require 'fog/core'
require 'fog/json'
require 'time'

module Fog
  module Softlayer
    extend Fog::Provider

    API_URL = 'api.softlayer.com/rest/v3' unless defined? API_URL

    service(:compute, 'Compute')

    def self.mock_account_id
      Fog.mocking? and @sl_account_id ||= Fog::Mock.random_numbers(7)
    end

    def self.mock_vm_id
      Fog::Mock.random_numbers(7)
    end

    def self.mock_global_identifier
      Fog::UUID.uuid
    end

    def self.valid_request?(required, passed)
      required.all? {|k| k = k.to_sym; passed.key?(k) and !passed[k].nil?}
    end

  end
end
