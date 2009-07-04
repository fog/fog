require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha2'

require File.dirname(__FILE__) + '/ec2/parsers'

module Fog
  module AWS
    class EC2

      # Initialize connection to EC2
      #
      # ==== Notes
      # options parameter must include values for :aws_access_key_id and 
      # :aws_secret_access_key in order to create a connection
      #
      # ==== Examples
      # sdb = SimpleDB.new(
      #  :aws_access_key_id => your_aws_access_key_id,
      #  :aws_secret_access_key => your_aws_secret_access_key
      # )
      #
      # ==== Parameters
      # options<~Hash>:: config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # SimpleDB object with connection to aws.
      def initialize(options={})
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA256.new(@aws_secret_access_key)
        @host       = options[:host]      || 'ec2.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = AWS::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      # Acquire an elastic IP address.
      #
      # ==== Returns
      #   body<~Hash>::
      #     :public_ip<~String>:: The acquired address
      def allocate_address
        request({
          'Action' => 'AllocateAddress'
        }, Fog::Parsers::AWS::EC2::AllocateAddress.new)
      end

      # Create an EBS volume
      #
      # ==== Parameters
      # availability_zone<~String>:: availability zone to create volume in
      # size<~Integer>:: Size in GiBs for volume.  Must be between 1 and 1024.
      # snapshot_id<~String>:: Optional, snapshot to create volume from
      #
      # ==== Returns
      # response::
      #   body<~Hash>::
      #     :volume_id<~String>:: Reference to volume
      #     :size<~Integer>:: Size in GiBs for volume
      #     :status<~String>:: State of volume
      #     :create_time<~Time>:: Timestamp for creation
      #     :availability_zone<~String>:: Availability zone for volume
      #     :snapshot_id<~String>:: Snapshot volume was created from, if any
      def create_volume(availability_zone, size, snapshot_id = nil)
        request({
          'Action' => 'CreateVolume',
          'AvailabilityZone' => availability_zone,
          'Size' => size,
          'SnapshotId' => snapshot_id
        }, Fog::Parsers::AWS::EC2::CreateVolume.new)
      end

      # Delete an EBS volume
      #
      # ==== Parameters
      # volume_id<~String>:: Id of volume to delete.
      #
      # ==== Returns
      # response::
      #   body<~Hash>::
      #     :return<~Boolean>:: success?
      def delete_volume(volume_id)
        request({
          'Action' => 'DeleteVolume',
          'VolumeId' => volume_id
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

      # Describe all or specified IP addresses.
      #
      # ==== Parameters
      # public_ips<~Array>:: List of ips to describe, defaults to all
      #
      # ==== Returns
      # body<~Hash>::
      #   :request_id<~String>:: Id of request
      #   :address_set<~Array>:: Addresses
      #     :instance_id<~String>:: instance for ip address
      #     :public_ip<~String>:: ip address for instance
      def describe_addresses(public_ips = [])
        params = indexed_params('PublicIp', public_ips)
        request({
          'Action' => 'DescribeAddresses'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeAddresses.new)
      end
      
      # Describe all or specified images.
      #
      # ==== Params
      # :options<~Hash>:: Optional params
      #   :executable_by<~String>:: Only return images the user specified by
      #     executable_by has explicit permission to launch
      #   :image_id<~Array>:: Ids of images to describe
      #   :owner<~String>:: Only return images belonging to owner.
      #
      # ==== Returns
      # body<~Hash>::
      #   :request_id<~String>:: Id of request
      #   :image_set<~Array>:: Images
      #     :architecture<~String>:: Architecture of the image
      #     :image_id<~String>:: Id of the image
      #     :image_location<~String>:: Location of the image
      #     :image_owner_id<~String>:: Id of the owner of the image
      #     :image_state<~String>:: State of the image
      #     :image_type<~String>:: Type of the image
      #     :is_public<~Boolean:: Whether or not the image is public
      def describe_images(options = {})
        params = {}
        if options[:image_id]
          params = indexed_params('ImageId', options[:image_id])
        end
        request({
          'Action' => 'DescribeImages',
          'ExecutableBy' => options[:executable_by],
          'Owner' => options[:owner]
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeImages.new)
      end
      
      # Describe all or specified volumes.
      #
      # ==== Parameters
      # volume_ids<~Array>:: List of volumes to describe, defaults to all
      #
      # ==== Returns
      # response::
      #   body<~Hash>::
      #     volume_set<~Array>::
      #       :volume_id<~String>:: Reference to volume
      #       :size<~Integer>:: Size in GiBs for volume
      #       :status<~String>:: State of volume
      #       :create_time<~Time>:: Timestamp for creation
      #       :availability_zone<~String>:: Availability zone for volume
      #       :snapshot_id<~String>:: Snapshot volume was created from, if any
      #       :attachment_set<~Array>::
      #         :attachment_time<~Time>:: Timestamp for attachment
      #         :device<~String>:: How volue is exposed to instance
      #         :instance_id<~String>:: Reference to attached instance
      #         :status<~String>:: Attachment state
      #         :volume_id<~String>:: Reference to volume
      def describe_volumes(volume_ids = [])
        params = indexed_params('VolumeId', volume_ids)
        request({
          'Action' => 'DescribeVolumes'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeVolumes.new)
      end

      # Release an elastic IP address.
      #
      # ==== Returns
      # response::
      #   body<~Hash>::
      #     :return<~Boolean>:: success?
      def release_address(public_ip)
        request({
          'Action' => 'ReleaseAddress',
          'PublicIp' => public_ip
        }, Fog::Parsers::AWS::EC2::Basic.new)
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
          :body => body,
          :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' },
          :host => @host,
          :method => 'POST'
        })

        if parser && !response.body.empty?
          Nokogiri::XML::SAX::Parser.new(parser).parse(response.body.split(/<\?xml.*\?>/)[1])
          response.body = parser.response
        end

        response
      end

    end
  end
end
