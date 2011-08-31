require File.expand_path(File.join(File.dirname(__FILE__), '..', 'virtual_box'))
require 'fog/compute'

module Fog
  module Compute
    class VirtualBox < Fog::Service

      model_path 'fog/virtual_box/models/compute'
      model       :medium
      collection  :mediums
      model       :medium_format
      model       :nat_engine
      model       :nat_redirect
      collection  :nat_redirects
      model       :network_adapter
      collection  :network_adapters
      model       :server
      collection  :servers
      model       :storage_controller
      collection  :storage_controllers

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def initialize(options={})
          require 'virtualbox'
          @connection = ::VirtualBox::Global.global.lib.virtualbox
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
