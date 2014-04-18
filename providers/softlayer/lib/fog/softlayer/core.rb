require 'fog/core'
require 'fog/json'
require 'time'

module Fog
  module Softlayer
    extend Fog::Provider

    API_URL = 'api.softlayer.com/rest/v3' unless defined? API_URL

    service(:compute, 'Compute')

    def self.load_requests(service)
      path = "providers/softlayer/lib/fog/softlayer/requests/#{service}"
      Dir.entries(path).reject{|e| e =~ /^\./}.each do |file|
        _request = File.basename(file, '.rb')
        yield _request.to_sym
      end
    end

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
      required.all? {|k| passed.key?(k) and !passed[k].nil?}
    end

  end
end
