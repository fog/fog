module Fog
  module AWS
    class Compute < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/aws'
      model       :address
      collection  :addresses
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :key_pair
      collection  :key_pairs
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

      request_path 'fog/compute/requests/aws'
      request :allocate_address
      request :associate_address
      request :attach_volume
      request :authorize_security_group_ingress
      request :create_image
      request :create_key_pair
      request :create_security_group
      request :create_snapshot
      request :create_tags
      request :create_volume
      request :delete_key_pair
      request :delete_security_group
      request :delete_snapshot
      request :delete_tags
      request :delete_volume
      request :deregister_image
      request :describe_addresses
      request :describe_availability_zones
      request :describe_images
      request :describe_instances
      request :describe_reserved_instances
      request :describe_key_pairs
      request :describe_regions
      request :describe_reserved_instances_offerings
      request :describe_security_groups
      request :describe_snapshots
      request :describe_tags
      request :describe_volumes
      request :detach_volume
      request :disassociate_address
      request :get_console_output
      request :import_key_pair
      request :modify_image_attributes
      request :modify_snapshot_attribute
      request :reboot_instances
      request :release_address
      request :register_image
      request :revoke_security_group_ingress
      request :run_instances
      request :terminate_instances
      request :start_instances
      request :stop_instances
      request :monitor_instances
      request :unmonitor_instances

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            owner_id = Fog::AWS::Mock.owner_id
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :deleted_at => {},
                :addresses  => {},
                :images     => {},
                :instances  => {},
                :key_pairs  => {},
                :limits     => { :addresses => 5 },
                :owner_id   => owner_id,
                :security_groups => {
                  'default' => {
                    'groupDescription'  => 'default group',
                    'groupName'         => 'default',
                    'ipPermissions'     => [
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                        'fromPort'    => -1,
                        'toPort'      => -1,
                        'ipProtocol'  => 'icmp',
                        'ipRanges'    => []
                      },
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                        'fromPort'    => 0,
                        'toPort'      => 65535,
                        'ipProtocol'  => 'tcp',
                        'ipRanges'    => []
                      },
                      {
                        'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                        'fromPort'    => 0,
                        'toPort'      => 65535,
                        'ipProtocol'  => 'udp',
                        'ipRanges'    => []
                      }
                    ],
                    'ownerId'           => owner_id
                  }
                },
                :snapshots => {},
                :volumes => {},
                :tags => {}
              }
            end
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute.new is deprecated, use Fog::Compute.new(:provider => 'AWS') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'fog/compute/parsers/aws/basic'

          @aws_access_key_id = options[:aws_access_key_id]
          @region = options[:region] || 'us-east-1'

          @data = self.class.data[@region][@aws_access_key_id]
          @owner_id = @data[:owner_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
          @data = self.class.data[@region][@aws_access_key_id]
        end

        def apply_tag_filters(resources, filters)
          # tag-key: match resources tagged with this key (any value)
          if filters.has_key?('tag-key')
            value = filters.delete('tag-key')
            resources = resources.select{|r| r['tagSet'].has_key?(value)}
          end
          
          # tag-value: match resources tagged with this value (any key)
          if filters.has_key?('tag-value')
            value = filters.delete('tag-value')
            resources = resources.select{|r| r['tagSet'].values.include?(value)}
          end
          
          # tag:key: match resources taged with a key-value pair.  Value may be an array, which is OR'd.
          tag_filters = {}
          filters.keys.each do |key| 
            tag_filters[key.gsub('tag:', '')] = filters.delete(key) if /^tag:/ =~ key
          end
          for tag_key, tag_value in tag_filters
            resources = resources.select{|r| tag_value.include?(r['tagSet'][tag_key])}
          end
          
          resources
        end
      end

      class Real

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
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1']
        #
        # ==== Returns
        # * EC2 object with connection to aws.
        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::AWS::Compute.new is deprecated, use Fog::Compute.new(:provider => 'AWS') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'fog/core/parser'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)
          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host
            @path = endpoint.path
            @port = endpoint.port
            @scheme = endpoint.scheme
          else
            options[:region] ||= 'us-east-1'
            @host = options[:host] || case options[:region]
            when 'ap-northeast-1'
              'ec2.ap-northeast-1.amazonaws.com'
            when 'ap-southeast-1'
              'ec2.ap-southeast-1.amazonaws.com'
            when 'eu-west-1'
              'ec2.eu-west-1.amazonaws.com'
            when 'us-east-1'
              'ec2.us-east-1.amazonaws.com'
            when 'us-west-1'
              'ec2.us-west-1.amazonaws.com'
            else
              raise ArgumentError, "Unknown region: #{options[:region].inspect}"
            end
            @path   = options[:path]      || '/'
            @port   = options[:port]      || 443
            @scheme = options[:scheme]    || 'https'
          end
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        private
        
        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2010-08-31'
            }
          )

          begin
            response = @connection.request({
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
              when 'NotFound'
                Fog::AWS::Compute::NotFound.slurp(error, match[2])
              else
                Fog::AWS::Compute::Error.slurp(error, "#{match[1]} => #{match[2]}")
              end
            else
              raise error
            end
          end

          response
        end

      end
    end
  end
end
