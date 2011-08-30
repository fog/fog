module Fog
  module Compute
    class Vsphere < Fog::Service

      requires :vsphere_username, :vsphere_password, :vsphere_server
      recognizes :vsphere_port, :vsphere_path, :vsphere_ns
      recognizes :vsphere_rev, :vsphere_ssl

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = options[:vsphere_password]
          @vsphere_server   = options[:vsphere_server]
          @vsphere_port     = options[:vsphere_port] || 443
          @vsphere_path     = options[:vsphere_path] || '/sdk'
          @vsphere_ns       = options[:vsphere_ns] || 'urn:vim25'
          @vsphere_rev      = options[:vsphere_rev] || '4.0'
          @vsphere_ssl      = options[:vsphere_ssl] || true
          @vsphere_must_reauthenticate = false

          @connection = RbVmomi::VIM.new :host => @vsphere_server,
                                         :port => @vsphere_port,
                                         :path => @vsphere_path,
                                         :ns   => @vsphere_ns,
                                         :rev  => @vsphere_rev,
                                         :ssl  => @vsphere_ssl,
                                         :insecure => true

          # Negotiate the API revision
          if not options[:vsphere_rev]
            rev = @connection.serviceContent.about.apiVersion
            @connection.rev = [ rev, ENV['FOG_VSPHERE_REV'] || '4.1' ].min
          end

          @vsphere_is_vcenter = @connection.serviceContent.about.apiType == "VirtualCenter"

          authenticate
        end

        def reload
          raise NotImplementedError
        end

        def request
          raise NotImplementedError
        end

        private

        def authenticate
          begin
            @connection.serviceContent.sessionManager.Login :userName => @vsphere_username,
                                                            :password => @vsphere_password
          rescue RbVmomi::VIM::InvalidLogin => e
            raise Fog::Vsphere::Errors::ServiceError, e.message
          end
        end

      end

    end
  end
end
