require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xenserver'))
require 'fog/compute'

module Fog
  module Compute 
    class XenServer < Fog::Service

      require 'fog/xenserver/utilities'
      require 'fog/xenserver/parser'
      
      requires :xenserver_username
      requires :xenserver_password
      requires :xenserver_url
      recognizes :xenserver_defaults
      
      model_path 'fog/xenserver/models/compute'
      model :server
      collection :servers
      model :host
      collection :hosts
      collection :vifs
      model :vif
      collection :storage_repositories
      model :storage_repository
      collection :pools
      model :pool
      collection :vbds
      model :vbd
      collection :vdis
      model :vdi
      collection :networks
      model :network
      collection :pifs
      model  :pif
      collection :pbds
      model  :pbd
      model  :guest_metrics

      request_path 'fog/xenserver/requests/compute'
      request :create_server
      request :create_vif
      request :destroy_server
      request :destroy_vbd
      request :destroy_vdi
      request :shutdown_server
      request :start_vm
      request :start_server
      request :get_record
      request :get_records
      request :set_affinity
      request :reboot_server
    
      class Real
        
        attr_accessor :default_template

        def initialize(options={})
          @host        = options[:xenserver_url]
          @username    = options[:xenserver_username]
          @password    = options[:xenserver_password]
          @defaults    = options[:xenserver_defaults] || {}
          @connection  = Fog::XenServer::Connection.new(@host)
          @connection.authenticate(@username, @password)
        end

        def reload
          @connection.authenticate(@username, @password)
        end
        
        def default_template=(name)
          @defaults[:template] = name
        end

        def default_template
          return nil if @defaults[:template].nil?
          servers.all(:name_matches => @defaults[:template], :include_templates => true,
                      :include_custom_templates => true ).first
        end
        
        def default_network
          Fog::XenServer::Network.new( get_network( @defaults[:network] ) ) if @defaults[:network]
        end
        
      end
      
      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end
        
        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end
        
        def initialize(options={})
          @host        = options[:xenserver_pool_master]
          @username    = options[:xenserver_username]
          @password    = options[:xenserver_password]
          @connection  = Fog::Connection.new(@host)
          @connection.authenticate(@username, @password)
        end
        
      end
    end
  end
end


