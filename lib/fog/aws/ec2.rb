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

      def self.dependencies
        [
          "fog/aws/models/ec2/address.rb",
          "fog/aws/models/ec2/addresses.rb",
          "fog/aws/models/ec2/flavor.rb",
          "fog/aws/models/ec2/flavors.rb",
          "fog/aws/models/ec2/image.rb",
          "fog/aws/models/ec2/images.rb",
          "fog/aws/models/ec2/key_pair.rb",
          "fog/aws/models/ec2/key_pairs.rb",
          "fog/aws/models/ec2/security_group.rb",
          "fog/aws/models/ec2/security_groups.rb",
          "fog/aws/models/ec2/server.rb",
          "fog/aws/models/ec2/servers.rb",
          "fog/aws/models/ec2/snapshot.rb",
          "fog/aws/models/ec2/snapshots.rb",
          "fog/aws/models/ec2/volume.rb",
          "fog/aws/models/ec2/volumes.rb",
          "fog/aws/parsers/ec2/allocate_address.rb",
          "fog/aws/parsers/ec2/attach_volume.rb",
          "fog/aws/parsers/ec2/basic.rb",
          "fog/aws/parsers/ec2/create_key_pair.rb",
          "fog/aws/parsers/ec2/create_snapshot.rb",
          "fog/aws/parsers/ec2/create_volume.rb",
          "fog/aws/parsers/ec2/describe_addresses.rb",
          "fog/aws/parsers/ec2/describe_availability_zones.rb",
          "fog/aws/parsers/ec2/describe_images.rb",
          "fog/aws/parsers/ec2/describe_instances.rb",
          "fog/aws/parsers/ec2/describe_reserved_instances.rb",
          "fog/aws/parsers/ec2/describe_key_pairs.rb",
          "fog/aws/parsers/ec2/describe_regions.rb",
          "fog/aws/parsers/ec2/describe_security_groups.rb",
          "fog/aws/parsers/ec2/describe_snapshots.rb",
          "fog/aws/parsers/ec2/describe_volumes.rb",
          "fog/aws/parsers/ec2/detach_volume.rb",
          "fog/aws/parsers/ec2/get_console_output.rb",
          "fog/aws/parsers/ec2/run_instances.rb",
          "fog/aws/parsers/ec2/terminate_instances.rb",
          "fog/aws/requests/ec2/allocate_address.rb",
          "fog/aws/requests/ec2/associate_address.rb",
          "fog/aws/requests/ec2/attach_volume.rb",
          "fog/aws/requests/ec2/authorize_security_group_ingress.rb",
          "fog/aws/requests/ec2/create_key_pair.rb",
          "fog/aws/requests/ec2/create_security_group.rb",
          "fog/aws/requests/ec2/create_snapshot.rb",
          "fog/aws/requests/ec2/create_volume.rb",
          "fog/aws/requests/ec2/delete_key_pair.rb",
          "fog/aws/requests/ec2/delete_security_group.rb",
          "fog/aws/requests/ec2/delete_snapshot.rb",
          "fog/aws/requests/ec2/delete_volume.rb",
          "fog/aws/requests/ec2/describe_addresses.rb",
          "fog/aws/requests/ec2/describe_availability_zones.rb",
          "fog/aws/requests/ec2/describe_images.rb",
          "fog/aws/requests/ec2/describe_instances.rb",
          "fog/aws/requests/ec2/describe_reserved_instances.rb",
          "fog/aws/requests/ec2/describe_key_pairs.rb",
          "fog/aws/requests/ec2/describe_regions.rb",
          "fog/aws/requests/ec2/describe_security_groups.rb",
          "fog/aws/requests/ec2/describe_snapshots.rb",
          "fog/aws/requests/ec2/describe_volumes.rb",
          "fog/aws/requests/ec2/detach_volume.rb",
          "fog/aws/requests/ec2/disassociate_address.rb",
          "fog/aws/requests/ec2/get_console_output.rb",
          "fog/aws/requests/ec2/reboot_instances.rb",
          "fog/aws/requests/ec2/release_address.rb",
          "fog/aws/requests/ec2/revoke_security_group_ingress.rb",
          "fog/aws/requests/ec2/run_instances.rb",
          "fog/aws/requests/ec2/terminate_instances.rb"
        ]
      end

      def self.reload
        self.dependencies.each {|dependency| load(dependency)}
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
      #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1']
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
        @host = options[:host] || case options[:region]
        when 'eu-west-1'
          'ec2.eu-west-1.amazonaws.com'
        when 'us-east-1'
          'ec2.us-east-1.amazonaws.com'
        when 'us-west-1'
          'ec2.us-west-1.amazonaws.com'
        else
          'ec2.amazonaws.com'
        end
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
      end

      private

      def request(params)
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")

        idempotent = params.delete(:idempotent)
        parser = params.delete(:parser)

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
          :body       => body,
          :expects    => 200,
          :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :idempotent => idempotent,
          :host       => @host,
          :method     => 'POST',
          :parser     => parser
        })

        response
      end

    end
  end
end

Fog::AWS::EC2.reload
