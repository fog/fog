require 'fog/storm_on_demand'
require 'fog/storm_on_demand/shared'
require 'fog/network'

module Fog
  module Network
    class StormOnDemand < Fog::Service

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/network'
      model       :balancer
      collection  :balancers
      model       :network_ip
      collection  :network_ips
      model       :private_ip
      collection  :private_ips
      model       :firewall
      collection  :firewalls
      model       :ruleset
      collection  :rulesets
      model       :pool
      collection  :pools
      model       :zone
      collection  :zones

      request_path 'fog/storm_on_demand/requests/network'
      request :remove_balancer_node
      request :add_balancer_node
      request :add_balancer_service
      request :remove_balancer_service
      request :check_balancer_available
      request :create_balancer
      request :delete_balancer
      request :update_balancer
      request :get_balancer_details
      request :list_balancers
      request :get_balancer_possible_nodes
      request :get_balancer_strategies

      request :list_private_ips
      request :get_private_ip
      request :attach_server_to_private_ip
      request :detach_server_from_private_ip
      request :check_server_attached

      request :add_ip_to_server
      request :get_ip_details
      request :list_network_ips
      request :list_ip_public_accounts
      request :list_network_public_ips
      request :remove_ip_from_server
      request :request_new_ips

      request :get_firewall
      request :get_firewall_basic_options
      request :get_firewall_rules
      request :update_firewall

      request :create_ruleset
      request :get_ruleset
      request :list_rulesets
      request :update_ruleset

      request :create_pool
      request :delete_pool
      request :get_pool
      request :get_assignments
      request :update_pool

      request :get_zone
      request :list_zones
      request :set_default_zone

      class Mock

        def self.data
          @data ||= Hash.new
        end

        def self.reset
          @data = nil
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @storm_on_demand_username = options[:storm_on_demand_username]
        end

        def data
          self.class.data[@storm_on_demand_username]
        end

        def reset_data
          self.class.data.delete(@storm_on_demand_username)
        end

      end

      class Real

        include Fog::StormOnDemand::RealShared

      end
    end
  end
end
