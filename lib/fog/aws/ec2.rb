module Fog
  module AWS
    class EC2

      if Fog.mocking?
        def self.data
          @data
        end
        def self.reset_data
          @data = {
            :deleted_at => {},
            :addresses => {},
            :instances => {},
            :key_pairs => {},
            :security_groups => {},
            :snapshots => {},
            :volumes => {}
          }
        end
      end

      def self.reload
        load "fog/aws/models/ec2/address.rb"
        load "fog/aws/models/ec2/addresses.rb"
        load "fog/aws/models/ec2/flavor.rb"
        load "fog/aws/models/ec2/flavors.rb"
        load "fog/aws/models/ec2/image.rb"
        load "fog/aws/models/ec2/images.rb"
        load "fog/aws/models/ec2/key_pair.rb"
        load "fog/aws/models/ec2/key_pairs.rb"
        load "fog/aws/models/ec2/security_group.rb"
        load "fog/aws/models/ec2/security_groups.rb"
        load "fog/aws/models/ec2/server.rb"
        load "fog/aws/models/ec2/servers.rb"
        load "fog/aws/models/ec2/snapshot.rb"
        load "fog/aws/models/ec2/snapshots.rb"
        load "fog/aws/models/ec2/volume.rb"
        load "fog/aws/models/ec2/volumes.rb"

        load "fog/aws/parsers/ec2/allocate_address.rb"
        load "fog/aws/parsers/ec2/attach_volume.rb"
        load "fog/aws/parsers/ec2/basic.rb"
        load "fog/aws/parsers/ec2/create_key_pair.rb"
        load "fog/aws/parsers/ec2/create_snapshot.rb"
        load "fog/aws/parsers/ec2/create_volume.rb"
        load "fog/aws/parsers/ec2/describe_addresses.rb"
        load "fog/aws/parsers/ec2/describe_availability_zones.rb"
        load "fog/aws/parsers/ec2/describe_images.rb"
        load "fog/aws/parsers/ec2/describe_instances.rb"
        load "fog/aws/parsers/ec2/describe_key_pairs.rb"
        load "fog/aws/parsers/ec2/describe_regions.rb"
        load "fog/aws/parsers/ec2/describe_security_groups.rb"
        load "fog/aws/parsers/ec2/describe_snapshots.rb"
        load "fog/aws/parsers/ec2/describe_volumes.rb"
        load "fog/aws/parsers/ec2/detach_volume.rb"
        load "fog/aws/parsers/ec2/get_console_output.rb"
        load "fog/aws/parsers/ec2/run_instances.rb"
        load "fog/aws/parsers/ec2/terminate_instances.rb"

        load "fog/aws/requests/ec2/allocate_address.rb"
        load "fog/aws/requests/ec2/associate_address.rb"
        load "fog/aws/requests/ec2/attach_volume.rb"
        load "fog/aws/requests/ec2/authorize_security_group_ingress.rb"
        # TODO: require "fog/aws/requests/ec2/bundle_instance.rb"
        # TODO: require "fog/aws/requests/ec2/cancel_bundle_task.rb"
        # TODO: require "fog/aws/requests/ec2/confirm_product_instance.rb"
        load "fog/aws/requests/ec2/create_key_pair.rb"
        load "fog/aws/requests/ec2/create_security_group.rb"
        load "fog/aws/requests/ec2/create_snapshot.rb"
        load "fog/aws/requests/ec2/create_volume.rb"
        load "fog/aws/requests/ec2/delete_key_pair.rb"
        load "fog/aws/requests/ec2/delete_security_group.rb"
        load "fog/aws/requests/ec2/delete_snapshot.rb"
        load "fog/aws/requests/ec2/delete_volume.rb"
        # TODO: require "fog/aws/requests/ec2/deregister_image.rb"
        load "fog/aws/requests/ec2/describe_addresses.rb"
        load "fog/aws/requests/ec2/describe_availability_zones.rb"
        # TODO: require "fog/aws/requests/ec2/describe_bundle_tasks.rb"
        # TODO: require "fog/aws/requests/ec2/describe_image_attribute.rb"
        load "fog/aws/requests/ec2/describe_images.rb"
        load "fog/aws/requests/ec2/describe_instances.rb"
        load "fog/aws/requests/ec2/describe_key_pairs.rb"
        load "fog/aws/requests/ec2/describe_regions.rb"
        # TODO: require "fog/aws/requests/ec2/describe_reserved_instances.rb"
        # TODO: require "fog/aws/requests/ec2/describe_reserved_instances_offerings.rb"
        load "fog/aws/requests/ec2/describe_security_groups.rb"
        load "fog/aws/requests/ec2/describe_snapshots.rb"
        load "fog/aws/requests/ec2/describe_volumes.rb"
        load "fog/aws/requests/ec2/detach_volume.rb"
        load "fog/aws/requests/ec2/disassociate_address.rb"
        load "fog/aws/requests/ec2/get_console_output.rb"
        # TODO: require "fog/aws/requests/ec2/modify_image_attribute.rb"
        # TODO: require "fog/aws/requests/ec2/modify_snapshot_attribute.rb"
        # TODO: require "fog/aws/requests/ec2/monitor_instances.rb"
        # TODO: require "fog/aws/requests/ec2/purchase_reserved_instances_offering.rb"
        load "fog/aws/requests/ec2/reboot_instances.rb"
        # TODO: require "fog/aws/requests/ec2/register_image.rb"
        load "fog/aws/requests/ec2/release_address.rb"
        # TODO: require "fog/aws/requests/ec2/reset_image_attributes.rb"
        # TODO: require "fog/aws/requests/ec2/reset_snapshot_attributes.rb"
        load "fog/aws/requests/ec2/revoke_security_group_ingress.rb"
        load "fog/aws/requests/ec2/run_instances.rb"
        load "fog/aws/requests/ec2/terminate_instances.rb"
        # TODO: require "fog/aws/requests/ec2/unmonitor_instances.rb"

        if Fog.mocking?
          reset_data
        end

      end

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
      #
      # ==== Returns
      # * EC2 object with connection to aws.
      def initialize(options={})
        unless @aws_access_key_id = options[:aws_access_key_id]
          raise ArgumentError.new('aws_access_key_id is required to access ec2')
        end
        unless @aws_secret_access_key = options[:aws_secret_access_key]
          raise ArgumentError.new('aws_secret_access_key is required to access ec2')
        end
        @hmac       = HMAC::SHA256.new(@aws_secret_access_key)
        @host       = options[:host]      || 'ec2.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      private

      def indexed_params(name, params)
        indexed, index = {}, 1
        for param in [*params]
          indexed["#{name}.#{index}"] = param
          index += 1
        end
        indexed
      end

      def request(params, parser)
        params.merge!({
          'AWSAccessKeyId' => @aws_access_key_id,
          'SignatureMethod' => 'HmacSHA256',
          'SignatureVersion' => '2',
          'Timestamp' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
          'Version' => '2009-11-30'
        })

        body = ''
        for key in params.keys.sort
          unless (value = params[key]).nil?
            body << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')}&"
          end
        end

        string_to_sign = "POST\n#{@host}\n/\n" << body.chop
        hmac = @hmac.update(string_to_sign)
        body << "Signature=#{CGI.escape(Base64.encode64(hmac.digest).chomp!).gsub(/\+/, '%20')}"

        response = @connection.request({
          :body     => body,
          :expects  => 200,
          :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :host     => @host,
          :method   => 'POST',
          :parser   => parser
        })

        response
      end

    end
  end
end

Fog::AWS::EC2.reload
