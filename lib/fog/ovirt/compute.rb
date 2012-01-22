
module Fog
  module Compute
    class Ovirt < Fog::Service

      requires   :ovirt_username, :ovirt_password
      recognizes :ovirt_url,      :ovirt_server,  :ovirt_port, :ovirt_api_path, :ovirt_datacenter

      model_path 'fog/ovirt/models/compute'
      model      :server
      collection :servers
      model      :template
      collection :templates
      model      :cluster
      collection :clusters

      request_path 'fog/ovirt/requests/compute'

      request :vm_action
      request :destroy_vm
      request :datacenters
      request :storage_domains

      class Mock

        def initialize(options={})
          username = options[:ovirt_username]
          password = options[:password]
          url      = options[:ovirt_url]
        end

      end

      class Real
        attr_reader :client

        def initialize(options={})
          require 'rbovirt'
          username   = options[:ovirt_username]
          password   = options[:ovirt_password]
          server     = options[:ovirt_server]
          port       = options[:ovirt_port]       || 8080
          api_path   = options[:ovirt_api_path]   || '/api'
          url        = options[:ovirt_url]        || "#{@scheme}://#{@ovirt_server}:#{@ovirt_port}#{@ovirt_api_path}"
          datacenter = options[:ovirt_datacenter]

          @client = OVIRT::Client.new(username, password, url, datacenter)
        end
      end
    end
  end
end
