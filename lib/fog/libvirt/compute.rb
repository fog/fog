require File.expand_path(File.join(File.dirname(__FILE__), '..', 'libvirt'))
require 'fog/compute'

require 'fog/libvirt/models/compute/uri'

module Fog
  module Compute
    class Libvirt < Fog::Service

      requires :libvirt_uri

      model_path 'fog/libvirt/models/compute'
      model       :server
      collection  :servers
      model       :network
      collection  :networks
      model       :interface
      collection  :interfaces
      model       :volume
      collection  :volumes
      model       :pool
      collection  :pools
      model       :node
      collection  :nodes

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        attr_reader :raw
        attr_reader :uri
        attr_reader :ip_command


        def initialize(options={})
          @uri = ::Fog::Compute::LibvirtUtil::URI.new(enhance_uri(options[:libvirt_uri]))
          @ip_command = options[:libvirt_ip_command]

          # libvirt is part of the gem => ruby-libvirt
          require 'libvirt'

          begin
            if options[:libvirt_username] and options[:libvirt_password]
              @raw = ::Libvirt::open_auth(@uri.uri, [::Libvirt::CRED_AUTHNAME, ::Libvirt::CRED_PASSPHRASE]) do |cred|
                if cred['type'] == ::Libvirt::CRED_AUTHNAME
                  res = options[:libvirt_username]
                elsif cred["type"] == ::Libvirt::CRED_PASSPHRASE
                  res = options[:libvirt_password]
                else
                end
              end
            else
              @raw = ::Libvirt::open(@uri.uri)
            end

          rescue ::Libvirt::ConnectionError
            raise Fog::Errors::Error.new("Error making a connection to libvirt URI #{@uri.uri}:\n#{$!}")
          end

        end

        def enhance_uri(uri)
          require 'cgi'
          append=""

          # on macosx, chances are we are using libvirt through homebrew
          # the client will default to a socket location based on it's own location (/opt)
          # we conveniently point it to /var/run/libvirt/libvirt-sock
          # if no socket option has been specified explicitly

          if RUBY_PLATFORM =~ /darwin/
            querystring=::URI.parse(uri).query
            if querystring.nil?
              append="?socket=/var/run/libvirt/libvirt-sock"
            else
              if !::CGI.parse(querystring).has_key?("socket")
                append="&socket=/var/run/libvirt/libvirt-sock"
              end
            end
          end
          newuri=uri+append
          return newuri
        end


        # hack to provide 'requests'
        def method_missing(method_sym, *arguments, &block)
          if @raw.respond_to?(method_sym)
            @raw.send(method_sym, *arguments)
          else
            super
          end
        end

      end
    end
  end
end
