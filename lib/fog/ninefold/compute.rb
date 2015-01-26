require 'fog/ninefold/core'

module Fog
  module Compute
    class Ninefold < Fog::Service
      API_URL = "http://api.ninefold.com/compute/v1.0/"

      requires :ninefold_compute_key, :ninefold_compute_secret
      recognizes :ninefold_api_url  # allow us to specify non-prod environments

      model_path 'fog/ninefold/models/compute'
      model       :server
      collection  :servers
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :address
      collection  :addresses
      model       :ip_forwarding_rule
      collection  :ip_forwarding_rules

      request_path 'fog/ninefold/requests/compute'
      # General list-only stuff
      request :list_accounts
      request :list_events
      request :list_service_offerings
      request :list_disk_offerings
      request :list_capabilities
      request :list_hypervisors
      request :list_zones
      request :list_network_offerings
      request :list_resource_limits
      # Templates
      request :list_templates
      # Virtual Machines
      request :deploy_virtual_machine
      request :destroy_virtual_machine
      request :list_virtual_machines
      request :reboot_virtual_machine
      request :stop_virtual_machine
      request :start_virtual_machine
      request :change_service_for_virtual_machine
      request :reset_password_for_virtual_machine
      request :update_virtual_machine
      # Jobs
      request :list_async_jobs
      request :query_async_job_result
      # Networks
      request :list_networks
      # Addresses
      request :associate_ip_address
      request :list_public_ip_addresses
      request :disassociate_ip_address
      # NAT
      request :enable_static_nat
      request :disable_static_nat
      request :create_ip_forwarding_rule
      request :delete_ip_forwarding_rule
      request :list_ip_forwarding_rules
      # Load Balancers
      request :create_load_balancer_rule
      request :delete_load_balancer_rule
      request :remove_from_load_balancer_rule
      request :assign_to_load_balancer_rule
      request :list_load_balancer_rules
      request :list_load_balancer_rule_instances
      request :update_load_balancer_rule

      class Mock
        def initialize(options)
          @api_url = options[:ninefold_api_url] || API_URL
          @ninefold_compute_key = options[:ninefold_compute_key]
          @ninefold_compute_secret = options[:ninefold_compute_secret]
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real
        def initialize(options)
          @api_url                  = options[:ninefold_api_url] || API_URL
          @ninefold_compute_key     = options[:ninefold_compute_key]
          @ninefold_compute_secret  = options[:ninefold_compute_secret]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent] || false
          @connection = Fog::XML::Connection.new(@api_url, @persistent, @connection_options)
        end

        def request(command, params, options)
          params['response'] = "json"
          # convert params to strings for sort
          req_params = params.merge('apiKey' => @ninefold_compute_key, 'command' => command)
          req = URI.escape(req_params.sort_by{|k,v| k.to_s }.map{|e| "#{e[0].to_s}=#{e[1].to_s}"}.join('&'))
          encoded_signature = url_escape(encode_signature(req))

          options = {
            :expects => 200,
            :method => 'GET',
            :query => "#{req}&signature=#{encoded_signature}"
          }.merge(options)

          begin
            response = @connection.request(options)
          end
          unless response.body.empty?
            # Because the response is some weird xml-json thing, we need to try and mung
            # the values out with a prefix, and if there is an empty data entry return an
            # empty version of the expected type (if provided)
            response = Fog::JSON.decode(response.body)
            if options.key? :response_prefix
              keys = options[:response_prefix].split('/')
              keys.each do |k|
                if response[k]
                  response = response[k]
                elsif options[:response_type]
                  response = options[:response_type].new
                  break
                else
                end
              end
              response
            else
              response
            end
          end
        end

        private
        def url_escape(string)
          string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
            '%' + $1.unpack('H2' * $1.size).join('%').upcase
          end.tr(' ', '+')
        end

        def encode_signature(data)
          Base64.encode64(OpenSSL::HMAC.digest('sha1', @ninefold_compute_secret, URI.encode(data.downcase).gsub('+', '%20'))).chomp
        end
      end
    end
  end
end
