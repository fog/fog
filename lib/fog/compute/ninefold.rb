module Fog
  module Ninefold
    class Compute < Fog::Service

      API_URL = "http://api.ninefold.com/compute/v1.0/"

      requires :ninefold_compute_key, :ninefold_compute_secret
      #recognizes :brightbox_auth_url, :brightbox_api_url
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/ninefold'
      #collection  :servers
      #model       :server
      #collection  :flavors
      #model       :flavor
      #collection  :images
      #model       :image
      #collection  :load_balancers
      #model       :load_balancer
      #collection  :zones
      #model       :zone
      #collection  :cloud_ips
      #model       :cloud_ip
      #collection  :users
      #model       :user

      request_path 'fog/compute/requests/ninefold'
      request :deploy_virtual_machine
      #request :activate_console_server
      #request :add_listeners_load_balancer
      #request :add_nodes_load_balancer
      #request :create_api_client
      #request :create_cloud_ip
      #request :create_image
      #request :create_load_balancer
      #request :destroy_api_client
      #request :destroy_cloud_ip
      #request :destroy_image
      #request :destroy_load_balancer
      #request :destroy_server
      #request :get_account
      #request :get_api_client
      #request :get_cloud_ip
      #request :get_image
      #request :get_interface
      #request :get_load_balancer
      #request :get_server
      #request :get_server_type
      #request :get_user
      #request :get_zone
      #request :list_api_clients
      #request :list_cloud_ips
      #request :list_images
      #request :list_load_balancers
      #request :list_server_types
      #request :list_servers
      #request :list_users
      #request :list_zones
      #request :map_cloud_ip
      #request :remove_listeners_load_balancer
      #request :remove_nodes_load_balancer
      #request :reset_ftp_password_account
      #request :resize_server
      #request :shutdown_server
      #request :snapshot_server
      #request :start_server
      #request :stop_server
      #request :unmap_cloud_ip
      #request :update_account
      #request :update_api_client
      #request :update_image
      #request :update_load_balancer
      #request :update_server
      #request :update_user

      class Mock

        def initialize(options)
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Ninefold::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Ninefold') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @brightbox_client_id = options[:brightbox_client_id] || Fog.credentials[:brightbox_client_id]
          @brightbox_secret = options[:brightbox_secret] || Fog.credentials[:brightbox_secret]
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real

        def initialize(options)
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Ninefold::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Ninefold') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require "json"

          @api_url = options[:ninefold_api_url] || Fog.credentials[:ninefold_api_url] || API_URL
          @ninefold_compute_key = options[:ninefold_compute_key] || Fog.credentials[:ninefold_compute_key]
          @ninefold_compute_secret = options[:ninefold_compute_secret] || Fog.credentials[:ninefold_compute_secret]
          @connection = Fog::Connection.new(@api_url)
        end

        def request(command, params, options)
          params["response"] = "json"
          req = "apiKey=#{@ninefold_compute_key}&command=#{command}&"
          req += URI.escape(params.sort.collect{|e| "#{e[0].to_s}=#{e[1].to_s}"}.join('&'))
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
            response = JSON.parse(response.body)
          end
        end

      private
        def url_escape(string)
          string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
            '%' + $1.unpack('H2' * $1.size).join('%').upcase
          end.tr(' ', '+')
        end

        def encode_signature(data)
          p @ninefold_compute_secret
          Base64.encode64(OpenSSL::HMAC.digest('sha1', @ninefold_compute_secret, URI.encode(data.downcase).gsub('+', '%20'))).chomp
        end
      end
    end
  end
end
