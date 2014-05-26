require 'fog/core'
require 'fog/xml'
require 'fog/internet_archive/signaturev4'

module Fog
  module InternetArchive
    COMPLIANT_BUCKET_NAMES = /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\-(?![\.])){1,61}[a-z0-9]$/

    DOMAIN_NAME = 'archive.org'

    API_DOMAIN_NAME = 's3.us.' + DOMAIN_NAME

    extend Fog::Provider

    service(:storage, 'Storage')

    def self.indexed_param(key, values)
      params = {}
      unless key.include?('%d')
        key << '.%d'
      end
      [*values].each_with_index do |value, index|
        if value.respond_to?('keys')
          k = format(key, index + 1)
          value.each do | vkey, vvalue |
            params["#{k}.#{vkey}"] = vvalue
          end
        else
          params[format(key, index + 1)] = value
        end
      end
      params
    end

    def self.serialize_keys(key, value, options = {})
      case value
      when Hash
        value.each do | k, v |
          options.merge!(serialize_keys("#{key}.#{k}", v))
        end
        return options
      when Array
        value.each_with_index do | it, idx |
          options.merge!(serialize_keys("#{key}.member.#{(idx + 1)}", it))
        end
        return options
      else
        return {key => value}
      end
    end

    def self.indexed_request_param(name, values)
      idx = -1
      Array(values).reduce({}) do |params, value|
        params["#{name}.#{idx += 1}"] = value
        params
      end
    end

    def self.indexed_filters(filters)
      params = {}
      filters.keys.each_with_index do |key, key_index|
        key_index += 1
        params[format('Filter.%d.Name', key_index)] = key
        [*filters[key]].each_with_index do |value, value_index|
          value_index += 1
          params[format('Filter.%d.Value.%d', key_index, value_index)] = value
        end
      end
      params
    end

    def self.escape(string)
      string.gsub(/([^a-zA-Z0-9_.\-~]+)/) {
        "%" + $1.unpack("H2" * $1.bytesize).join("%").upcase
      }
    end

    def self.signed_params(params, options = {})
      params.merge!({
        'AWSAccessKeyId'    => options[:ia_access_key_id],
        'SignatureMethod'   => 'HmacSHA256',
        'SignatureVersion'  => '2',
        'Timestamp'         => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        'Version'           => options[:version]
      })

      params.merge!({
        'SecurityToken'     => options[:ia_session_token]
      }) if options[:ia_session_token]

      body = ''
      for key in params.keys.sort
        unless (value = params[key]).nil?
          body << "#{key}=#{escape(value.to_s)}&"
        end
      end
      string_to_sign = "POST\n#{options[:host]}:#{options[:port]}\n#{options[:path]}\n" << body.chop
      signed_string = options[:hmac].sign(string_to_sign)
      body << "Signature=#{escape(Base64.encode64(signed_string).chomp!)}"

      body
    end

    class Mock
      def self.arn(vendor, account_id, path, region = nil)
        "arn:aws:#{vendor}:#{region}:#{account_id}:#{path}"
      end

      def self.availability_zone(region)
        "#{region}#{Fog::Mock.random_selection('abcd', 1)}"
      end

      def self.box_usage
        sprintf("%0.10f", rand / 100).to_f
      end

      def self.console_output
        # "[ 0.000000] Linux version 2.6.18-xenU-ec2-v1.2 (root@domU-12-31-39-07-51-82) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-13)) #2 SMP Wed Aug 19 09:04:38 EDT 2009"
        Base64.decode64("WyAwLjAwMDAwMF0gTGludXggdmVyc2lvbiAyLjYuMTgteGVuVS1lYzItdjEu\nMiAocm9vdEBkb21VLTEyLTMxLTM5LTA3LTUxLTgyKSAoZ2NjIHZlcnNpb24g\nNC4xLjIgMjAwNzA2MjYgKFJlZCBIYXQgNC4xLjItMTMpKSAjMiBTTVAgV2Vk\nIEF1ZyAxOSAwOTowNDozOCBFRFQgMjAwOQ==\n")
      end

      def self.dns_name_for(ip_address)
        "ec2-#{ip_address.gsub('.','-')}.compute-1.amazonaws.com"
      end

      def self.private_dns_name_for(ip_address)
        "ip-#{ip_address.gsub('.','-')}.ec2.internal"
      end

      def self.image
        path = []
        (rand(3) + 2).times do
          path << Fog::Mock.random_letters(rand(9) + 8)
        end
        {
          "imageOwnerId"   => Fog::Mock.random_letters(rand(5) + 4),
          "blockDeviceMapping" => [],
          "productCodes"   => [],
          "kernelId"       => kernel_id,
          "ramdiskId"      => ramdisk_id,
          "imageState"     => "available",
          "imageId"        => image_id,
          "architecture"   => "i386",
          "isPublic"       => true,
          "imageLocation"  => path.join('/'),
          "imageType"      => "machine",
          "rootDeviceType" => ["ebs","instance-store"][rand(2)],
          "rootDeviceName" => "/dev/sda1"
        }
      end

      def self.image_id
        "ami-#{Fog::Mock.random_hex(8)}"
      end

      def self.key_fingerprint
        fingerprint = []
        20.times do
          fingerprint << Fog::Mock.random_hex(2)
        end
        fingerprint.join(':')
      end

      def self.instance_id
        "i-#{Fog::Mock.random_hex(8)}"
      end

      def self.ip_address
        ip = []
        4.times do
          ip << Fog::Mock.random_numbers(rand(3) + 1).to_i.to_s # remove leading 0
        end
        ip.join('.')
      end

      def self.private_ip_address
        ip_address.gsub(/^\d{1,3}\./,"10.")
      end

      def self.kernel_id
        "aki-#{Fog::Mock.random_hex(8)}"
      end

      def self.key_material
        OpenSSL::PKey::RSA.generate(1024).to_s
      end

      def self.owner_id
        Fog::Mock.random_numbers(12)
      end

      def self.ramdisk_id
        "ari-#{Fog::Mock.random_hex(8)}"
      end

      def self.request_id
        request_id = []
        request_id << Fog::Mock.random_hex(8)
        3.times do
          request_id << Fog::Mock.random_hex(4)
        end
        request_id << Fog::Mock.random_hex(12)
        request_id.join('-')
      end
      class << self
        alias_method :reserved_instances_id, :request_id
        alias_method :reserved_instances_offering_id, :request_id
        alias_method :sqs_message_id, :request_id
        alias_method :sqs_sender_id, :request_id
      end

      def self.reservation_id
        "r-#{Fog::Mock.random_hex(8)}"
      end

      def self.snapshot_id
        "snap-#{Fog::Mock.random_hex(8)}"
      end

      def self.volume_id
        "vol-#{Fog::Mock.random_hex(8)}"
      end

      def self.security_group_id
        "sg-#{Fog::Mock.random_hex(8)}"
      end

      def self.network_interface_id
        "eni-#{Fog::Mock.random_hex(8)}"
      end
      def self.internet_gateway_id
        "igw-#{Fog::Mock.random_hex(8)}"
      end
      def self.dhcp_options_id
        "dopt-#{Fog::Mock.random_hex(8)}"
      end
      def self.vpc_id
        "vpc-#{Fog::Mock.random_hex(8)}"
      end
      def self.subnet_id
        "subnet-#{Fog::Mock.random_hex(8)}"
      end
      def self.zone_id
        "zone-#{Fog::Mock.random_hex(8)}"
      end
      def self.change_id
        "change-#{Fog::Mock.random_hex(8)}"
      end
      def self.nameservers
        [
          'ns-2048.awsdns-64.com',
          'ns-2049.awsdns-65.net',
          'ns-2050.awsdns-66.org',
          'ns-2051.awsdns-67.co.uk'
        ]
      end

      def self.key_id(length=21)
        #Probably close enough
        Fog::Mock.random_selection('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',length)
      end

      def self.rds_address(db_name,region)
        "#{db_name}.#{Fog::Mock.random_letters(rand(12) + 4)}.#{region}.rds.amazonaws.com"
      end
    end

    def self.parse_security_group_options(group_name, options)
      options ||= Hash.new
      if group_name.is_a?(Hash)
        options = group_name
      elsif group_name
        if options.key?('GroupName')
          raise Fog::Compute::InternetArchive::Error, 'Arguments specified both group_name and GroupName in options'
        end
        options = options.clone
        options['GroupName'] = group_name
      end
      name_specified = options.key?('GroupName') && !options['GroupName'].nil?
      group_id_specified = options.key?('GroupId') && !options['GroupId'].nil?
      unless name_specified || group_id_specified
        raise Fog::Compute::InternetArchive::Error, 'Neither GroupName nor GroupId specified'
      end
      if name_specified && group_id_specified
        options.delete('GroupName')
      end
      options
    end
  end
end
