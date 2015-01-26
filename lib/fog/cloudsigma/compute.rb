require 'fog/cloudsigma/core'
require 'fog/cloudsigma/connection'

module Fog
  module Compute
    class CloudSigma < Fog::Service
      requires :cloudsigma_password, :cloudsigma_username
      recognizes :cloudsigma_password, :cloudsigma_username, :cloudsigma_host

      model_path 'fog/cloudsigma/models'
      request_path 'fog/cloudsigma/requests'

      model :volume
      collection :volumes
      request :create_volume
      request :get_volume
      request :list_volumes
      request :update_volume
      request :delete_volume
      request :clone_volume

      model :lib_volume
      collection :lib_volumes
      request :get_lib_volume
      request :list_lib_volumes

      model :ipconf
      model :nic
      model :mountpoint
      model :server
      collection :servers
      request :create_server
      request :get_server
      request :list_servers
      request :update_server
      request :delete_server
      request :start_server
      request :stop_server
      request :open_vnc
      request :close_vnc
      request :clone_server

      model :ip
      collection :ips
      request :list_ips
      request :get_ip

      model :vlan
      collection :vlans
      request :list_vlans
      request :get_vlan
      request :update_vlan

      model :rule
      model :fwpolicy
      collection :fwpolicies
      request :list_fwpolicies

      model :subscription
      collection :subscriptions
      request :list_subscriptions
      request :get_subscription
      request :create_subscription
      request :extend_subscription

      model :price_calculation
      request :calculate_subscription_price

      model :profile
      request :get_profile
      request :update_profile

      model :balance
      request :get_balance

      model :current_usage
      request :get_current_usage

      model :pricing
      request :get_pricing

      module CommonMockAndReal
        def initialize(options={})
          @init_options = options

          setup_connection(options)
        end

        def profile
          response = get_profile
          Profile.new(response.body)
        end

        def balance
          response = get_balance

          Balance.new(response.body)
        end

        def current_usage
          response = get_current_usage

          CurrentUsage.new(response.body['usage'])
        end

        def currency
          # Cache since currency does not change
          @currency ||= profile.currency
        end

        def pricing
          resp = get_princing(currency)

          resp.body['objects']
        end

        def current_pricing_levels
          resp = get_pricing(currency)

          resp.body['current']
        end

        def next_pricing_levels
          resp = get_pricing(currency)

          resp.body['next']
        end

        def subscription_pricing
          resp = get_pricing(currency, true)

          current_levels = resp.body['current']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.find do |price|
              price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end

        def current_pricing
          resp = get_pricing(currency)

          current_levels = resp.body['current']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.find do |price|
              price['level'] == level && price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end

        def next_pricing
          resp = get_pricing(currency)

          current_levels = resp.body['next']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.find do |price|
              price['level'] == level && price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end
      end

      class Mock
        include Collections
        include CommonMockAndReal
        include Fog::CloudSigma::CloudSigmaConnection::Mock
        require 'fog/cloudsigma/mock_data'

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = mock_data
          end
        end

        def self.random_uuid
          # Insert '4' at 13th position and 'a' at 17th as per uuid4 spec
          hex = Fog::Mock.random_hex(30).insert(12,'4').insert(16, 'a')
          # Add dashes
          "#{hex[0...8]}-#{hex[8...12]}-#{hex[12...16]}-#{hex[16...20]}-#{hex[20..32]}"
        end

        def self.random_mac
          (0..5).map{Fog::Mock.random_hex(2)}.join(':')
        end

        def data
          self.class.data[:test]
        end
      end

      class Real
        include Collections
        include CommonMockAndReal
        include Fog::CloudSigma::CloudSigmaConnection::Real
      end
    end
  end
end
