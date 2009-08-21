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
            :key_pairs => {},
            :security_groups => {},
            :snapshots => {},
            :volumes => {}
          }
        end
      end

      def self.reload
        current_directory = File.dirname(__FILE__)
        load "#{current_directory}/../connection.rb"
        load "#{current_directory}/../parser.rb"
        load "#{current_directory}/../response.rb"

        parsers_directory = "#{current_directory}/parsers/ec2"
        load "#{parsers_directory}/allocate_address.rb"
        load "#{parsers_directory}/attach_volume.rb"
        load "#{parsers_directory}/basic.rb"
        load "#{parsers_directory}/create_key_pair.rb"
        load "#{parsers_directory}/create_snapshot.rb"
        load "#{parsers_directory}/create_volume.rb"
        load "#{parsers_directory}/describe_addresses.rb"
        load "#{parsers_directory}/describe_availability_zones.rb"
        load "#{parsers_directory}/describe_images.rb"
        load "#{parsers_directory}/describe_instances.rb"
        load "#{parsers_directory}/describe_key_pairs.rb"
        load "#{parsers_directory}/describe_regions.rb"
        load "#{parsers_directory}/describe_security_groups.rb"
        load "#{parsers_directory}/describe_snapshots.rb"
        load "#{parsers_directory}/describe_volumes.rb"
        load "#{parsers_directory}/detach_volume.rb"
        load "#{parsers_directory}/get_console_output.rb"
        load "#{parsers_directory}/run_instances.rb"
        load "#{parsers_directory}/terminate_instances.rb"

        requests_directory = "#{current_directory}/requests/ec2"
        load "#{requests_directory}/allocate_address.rb"
        load "#{requests_directory}/associate_address.rb"
        load "#{requests_directory}/attach_volume.rb"
        load "#{requests_directory}/authorize_security_group_ingress.rb"
        # TODO: require "#{requests_directory}/bundle_instance.rb"
        # TODO: require "#{requests_directory}/cancel_bundle_task.rb"
        # TODO: require "#{requests_directory}/confirm_product_instance.rb"
        load "#{requests_directory}/create_key_pair.rb"
        load "#{requests_directory}/create_security_group.rb"
        load "#{requests_directory}/create_snapshot.rb"
        load "#{requests_directory}/create_volume.rb"
        load "#{requests_directory}/delete_key_pair.rb"
        load "#{requests_directory}/delete_security_group.rb"
        load "#{requests_directory}/delete_snapshot.rb"
        load "#{requests_directory}/delete_volume.rb"
        # TODO: require "#{requests_directory}/deregister_image.rb"
        load "#{requests_directory}/describe_addresses.rb"
        load "#{requests_directory}/describe_availability_zones.rb"
        # TODO: require "#{requests_directory}/describe_bundle_tasks.rb"
        # TODO: require "#{requests_directory}/describe_image_attribute.rb"
        load "#{requests_directory}/describe_images.rb"
        load "#{requests_directory}/describe_instances.rb"
        load "#{requests_directory}/describe_key_pairs.rb"
        load "#{requests_directory}/describe_regions.rb"
        # TODO: require "#{requests_directory}/describe_reserved_instances.rb"
        # TODO: require "#{requests_directory}/describe_reserved_instances_offerings.rb"
        load "#{requests_directory}/describe_security_groups.rb"
        load "#{requests_directory}/describe_snapshots.rb"
        load "#{requests_directory}/describe_volumes.rb"
        load "#{requests_directory}/detach_volume.rb"
        load "#{requests_directory}/disassociate_address.rb"
        load "#{requests_directory}/get_console_output.rb"
        # TODO: require "#{requests_directory}/modify_image_attribute.rb"
        # TODO: require "#{requests_directory}/monitor_instances.rb"
        # TODO: require "#{requests_directory}/purchase_reserved_instances_offering.rb"
        load "#{requests_directory}/reboot_instances.rb"
        # TODO: require "#{requests_directory}/register_image.rb"
        load "#{requests_directory}/release_address.rb"
        load "#{requests_directory}/revoke_security_group_ingress.rb"
        load "#{requests_directory}/run_instances.rb"
        load "#{requests_directory}/terminate_instances.rb"
        # TODO: require "#{requests_directory}/unmonitor_instances.rb"

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
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
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
          'Version' => '2009-04-04'
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
