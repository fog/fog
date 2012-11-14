require 'fog/aws'
require 'fog/compute'

module Fog
  module Compute
    class AWS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent, :aws_session_token, :use_iam_profile, :aws_credentials_expire_at, :instrumentor, :instrumentor_name, :version

      secrets    :aws_secret_access_key, :hmac, :aws_session_token

      model_path 'fog/aws/models/compute'
      model       :address
      collection  :addresses
      model       :dhcp_options
      collection  :dhcp_options
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :internet_gateway
      collection  :internet_gateways
      model       :key_pair
      collection  :key_pairs
      model       :network_interface
      collection  :network_interfaces
      model       :security_group
      collection  :security_groups
      model       :server
      collection  :servers
      model       :snapshot
      collection  :snapshots
      model       :tag
      collection  :tags
      model       :volume
      collection  :volumes
      model       :spot_request
      collection  :spot_requests
      model       :subnet
      collection  :subnets
      model       :vpc
      collection  :vpcs

      request_path 'fog/aws/requests/compute'
      request :allocate_address
      request :associate_address
      request :associate_dhcp_options
      request :attach_network_interface
      request :attach_internet_gateway
      request :attach_volume
      request :authorize_security_group_ingress
      request :cancel_spot_instance_requests
      request :create_dhcp_options
      request :create_internet_gateway
      request :create_image
      request :create_key_pair
      request :create_network_interface
      request :create_placement_group
      request :create_security_group
      request :create_snapshot
      request :create_spot_datafeed_subscription
      request :create_subnet
      request :create_tags
      request :create_volume
      request :create_vpc
      request :delete_dhcp_options
      request :delete_internet_gateway
      request :delete_key_pair
      request :delete_network_interface
      request :delete_security_group
      request :delete_placement_group
      request :delete_snapshot
      request :delete_spot_datafeed_subscription
      request :delete_subnet
      request :delete_tags
      request :delete_volume
      request :delete_vpc
      request :deregister_image
      request :describe_addresses
      request :describe_availability_zones
      request :describe_dhcp_options
      request :describe_images
      request :describe_instances
      request :describe_internet_gateways
      request :describe_reserved_instances
      request :describe_instance_status
      request :describe_key_pairs
      request :describe_network_interface_attribute
      request :describe_network_interfaces
      request :describe_placement_groups
      request :describe_regions
      request :describe_reserved_instances_offerings
      request :describe_security_groups
      request :describe_snapshots
      request :describe_spot_datafeed_subscription
      request :describe_spot_instance_requests
      request :describe_spot_price_history
      request :describe_subnets
      request :describe_tags
      request :describe_volumes
      request :describe_volume_status
      request :describe_vpcs
      request :detach_network_interface
      request :detach_internet_gateway
      request :detach_volume
      request :disassociate_address
      request :get_console_output
      request :get_password_data
      request :import_key_pair
      request :modify_image_attribute
      request :modify_instance_attribute
      request :modify_network_interface_attribute
      request :modify_snapshot_attribute
      request :modify_volume_attribute
      request :purchase_reserved_instances_offering
      request :reboot_instances
      request :release_address
      request :register_image
      request :request_spot_instances
      request :reset_network_interface_attribute
      request :revoke_security_group_ingress
      request :run_instances
      request :terminate_instances
      request :start_instances
      request :stop_instances
      request :monitor_instances
      request :unmonitor_instances

      # deprecation
      class Real

        def modify_image_attributes(*params)
          Fog::Logger.deprecation("modify_image_attributes is deprecated, use modify_image_attribute instead [light_black](#{caller.first})[/]")
          modify_image_attribute(*params)
        end

      end

      class Mock
        include Fog::AWS::CredentialFetcher::ConnectionMethods

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              owner_id = Fog::AWS::Mock.owner_id
              security_group_id = Fog::AWS::Mock.security_group_id
              region_hash[key] = {
                :deleted_at => {},
                :addresses  => {},
                :images     => {},
                :image_launch_permissions => Hash.new do |permissions_hash, image_key|
                  permissions_hash[image_key] = {
                    :users => []
                  }
                end,
                :instances  => {},
                :reserved_instances => {},
                :key_pairs  => {},
                :limits     => { :addresses => 5 },
                :owner_id   => owner_id,
                :security_groups => {
                  'default' => {
                    'groupDescription'    => 'default group',
                    'groupName'           => 'default',
                    'groupId'             => security_group_id,
                    'ipPermissionsEgress' => [],
                    'ipPermissions'       => [
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id, 'groupId' => security_group_id }],
                        'fromPort'    => -1,
                        'toPort'      => -1,
                        'ipProtocol'  => 'icmp',
                        'ipRanges'    => []
                      },
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id, 'groupId' => security_group_id}],
                        'fromPort'    => 0,
                        'toPort'      => 65535,
                        'ipProtocol'  => 'tcp',
                        'ipRanges'    => []
                      },
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id, 'groupId' => security_group_id}],
                        'fromPort'    => 0,
                        'toPort'      => 65535,
                        'ipProtocol'  => 'udp',
                        'ipRanges'    => []
                      }
                    ],
                    'ownerId'             => owner_id
                  }
                },
                :network_interfaces => {},
                :snapshots => {},
                :volumes => {},
                :internet_gateways => {},
                :tags => {},
                :tag_sets => Hash.new do |tag_set_hash, resource_id|
                  tag_set_hash[resource_id] = {}
                end,
                :subnets => [],
                :vpcs => [],
                :dhcp_options => [],
                :internet_gateways => []
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        attr_accessor :region

        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]
          @aws_credentials_expire_at = Time::now + 20
          setup_credentials(options)
          @region = options[:region] || 'us-east-1'

          unless ['ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'sa-east-1'].include?(@region)
            raise ArgumentError, "Unknown region: #{@region.inspect}"
          end
        end

        def region_data
          self.class.data[@region]
        end

        def data
          self.region_data[@aws_access_key_id]
        end

        def reset_data
          self.region_data.delete(@aws_access_key_id)
        end

        def visible_images
          images = self.data[:images].values.inject({}) do |h, image|
            h.update(image['imageId'] => image)
          end

          self.region_data.each do |aws_access_key_id, data|
            data[:image_launch_permissions].each do |image_id, list|
              if list[:users].include?(self.data[:owner_id])
                images.update(image_id => data[:images][image_id])
              end
            end
          end

          images
        end

        def apply_tag_filters(resources, filters, resource_id_key)
          tag_set_fetcher = lambda {|resource| self.data[:tag_sets][resource[resource_id_key]] }

          # tag-key: match resources tagged with this key (any value)
          if filters.has_key?('tag-key')
            value = filters.delete('tag-key')
            resources = resources.select{|r| tag_set_fetcher[r].has_key?(value)}
          end

          # tag-value: match resources tagged with this value (any key)
          if filters.has_key?('tag-value')
            value = filters.delete('tag-value')
            resources = resources.select{|r| tag_set_fetcher[r].values.include?(value)}
          end

          # tag:key: match resources tagged with a key-value pair.  Value may be an array, which is OR'd.
          tag_filters = {}
          filters.keys.each do |key|
            tag_filters[key.gsub('tag:', '')] = filters.delete(key) if /^tag:/ =~ key
          end
          for tag_key, tag_value in tag_filters
            resources = resources.select{|r| tag_value.include?(tag_set_fetcher[r][tag_key])}
          end

          resources
        end

        def setup_credentials(options)
          @aws_access_key_id = options[:aws_access_key_id]
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to EC2
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   sdb = SimpleDB.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance,
        #     'eu-west-1', 'us-east-1', and etc.
        #   * aws_session_token<~String> - when using Session Tokens or Federated Users, a session_token must be presented
        #
        # ==== Returns
        # * EC2 object with connection to aws.

        attr_accessor :region

        def initialize(options={})
          require 'fog/core/parser'

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @connection_options     = options[:connection_options] || {}
          @region                 = options[:region] ||= 'us-east-1'
          @instrumentor           = options[:instrumentor]
          @instrumentor_name      = options[:instrumentor_name] || 'fog.aws.compute'
          @version                = options[:version]     ||  '2012-07-20'

          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host
            @path = endpoint.path
            @port = endpoint.port
            @scheme = endpoint.scheme
          else
            @host = options[:host] || "ec2.#{options[:region]}.amazonaws.com"
            @path       = options[:path]        || '/'
            @persistent = options[:persistent]  || false
            @port       = options[:port]        || 443
            @scheme     = options[:scheme]      || 'https'
          end
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private
        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac                   = Fog::HMAC.new('sha256', @aws_secret_access_key)
        end

        def request(params)
          refresh_credentials_if_expired
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = Fog::AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :aws_session_token  => @aws_session_token,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => @version
            }
          )

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(body, idempotent, parser)
            end
          else
            _request(body, idempotent, parser)
          end
        end

        def _request(body, idempotent, parser)
          @connection.request({
              :body       => body,
              :expects    => 200,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :idempotent => idempotent,
              :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })
        rescue Excon::Errors::HTTPStatusError => error
          if match = error.message.match(/<Code>(.*)<\/Code><Message>(.*)<\/Message>/)
            raise case match[1].split('.').last
                  when 'NotFound', 'Unknown'
                    Fog::Compute::AWS::NotFound.slurp(error, match[2])
                  else
                    Fog::Compute::AWS::Error.slurp(error, "#{match[1]} => #{match[2]}")
                  end
          else
            raise error
          end
        end

      end
    end
  end
end
