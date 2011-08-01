require 'fog/compute/models/libvirt/uri'

module Fog
  module Compute
    class Libvirt < Fog::Service

      requires :libvirt_uri

      model_path 'fog/compute/models/libvirt'
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

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        attr_reader :connection
        attr_reader :uri
        
        def initialize(options={})
          @uri = ::Fog::Compute::LibvirtUtil::URI.new(options[:libvirt_uri])

          # libvirt is part of the gem => ruby-libvirt
          require 'libvirt'
          @connection = ::Libvirt::open(@uri.uri)
        end

        # hack to provide 'requests'
        def method_missing(method_sym, *arguments, &block)
          if @connection.respond_to?(method_sym)
            @connection.send(method_sym, *arguments)
          else
            super
          end
        end
        
      end
    end
  end
end
