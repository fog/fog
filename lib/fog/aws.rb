require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module AWS

    extend Fog::Provider

    service(:auto_scaling,    'aws/auto_scaling')
    service(:cdn,             'aws/cdn')
    service(:compute,         'aws/compute')
    service(:cloud_formation, 'aws/cloud_formation')
    service(:cloud_watch,     'aws/cloud_watch')
    service(:dns,             'aws/dns')
    service(:elb,             'aws/elb')
    service(:iam,             'aws/iam')
    service(:rds,             'aws/rds')
    service(:ses,             'aws/ses')
    service(:simpledb,        'aws/simpledb')
    service(:sns,             'aws/sns')
    service(:sqs,             'aws/sqs')
    service(:storage,         'aws/storage')

    def self.indexed_param(key, values)
      params = {}
      unless key.include?('%d')
        key << '.%d'
      end
      [*values].each_with_index do |value, index|
        params[format(key, index + 1)] = value
      end
      params
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
        'AWSAccessKeyId'    => options[:aws_access_key_id],
        'SignatureMethod'   => 'HmacSHA256',
        'SignatureVersion'  => '2',
        'Timestamp'         => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        'Version'           => options[:version]
      })

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

      def self.etag
        Fog::Mock.random_hex(32)
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
        alias :reserved_instances_id :request_id
        alias :reserved_instances_offering_id :request_id
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
    end
  end
end
