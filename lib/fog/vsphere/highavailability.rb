require 'digest/sha2'
require 'fog/storage'
require 'time'
require_relative './vsphere_connection'

module Fog
  module Highavailability

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
        when :vsphere
          require 'fog/vsphere/highavailability'
          Fog::Highavailability::Vsphere.new(attributes)
        else
          raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

    class Vsphere < Fog::Service

      requires :vsphere_server
      recognizes :vsphere_username, :vsphere_password
      recognizes :vsphere_port, :vsphere_path, :vsphere_ns
      recognizes :vsphere_rev, :vsphere_ssl, :vsphere_expected_pubkey_hashs
      recognizes :cert, :key, :extension_key
      recognizes 'log_level'

      request_path 'fog/vsphere/requests/ha'
      request :vm_config_ha
      request :query_resources
      request :keep_alive


      module Shared

        attr_reader :vsphere_is_vcenter
        attr_reader :vsphere_rev
        attr_reader :vsphere_server
        attr_reader :vsphere_username

      end # end of shared module


      class Mock

        include Shared

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = 'REDACTED'
          @vsphere_server   = options[:vsphere_server]
          @vsphere_expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
          @vsphere_is_vcenter = true
          @vsphere_rev = '4.0'
        end

      end

      class Real

        include Shared

        def initialize(options={})
          Fog::Logger.set_log_level(options['log_level'])
          @connection = Fog::VsphereConnection.connect options
        end

        def close
          @connection.close
          @connection = nil
        rescue RbVmomi::fault => e
          raise Fog::Vsphere::Errors::ServiceError, e.message
        end

      end  # end of real
    end
  end
end
