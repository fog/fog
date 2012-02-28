require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module AWS

    extend Fog::Provider

    service(:auto_scaling,    'aws/auto_scaling',     'AutoScaling')
    service(:cdn,             'aws/cdn',              'CDN')
    service(:compute,         'aws/compute',          'Compute')
    service(:cloud_formation, 'aws/cloud_formation',  'CloudFormation')
    service(:cloud_watch,     'aws/cloud_watch',      'CloudWatch')
    service(:dynamodb,        'aws/dynamodb',         'DynamoDB')
    service(:dns,             'aws/dns',              'DNS')
    service(:elasticache,     'aws/elasticache',      'Elasticache')
    service(:elb,             'aws/elb',              'ELB')
    service(:emr,             'aws/emr',              'EMR')
    service(:iam,             'aws/iam',              'IAM')
    service(:rds,             'aws/rds',              'RDS')
    service(:ses,             'aws/ses',              'SES')
    service(:simpledb,        'aws/simpledb',         'SimpleDB')
    service(:sns,             'aws/sns',              'SNS')
    service(:sqs,             'aws/sqs',              'SQS')
    service(:sts,             'aws/sts',              'STS')
    service(:storage,         'aws/storage',          'Storage')

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

      params.merge!({
        'SecurityToken'     => options[:aws_session_token]
      }) if options[:aws_session_token]

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
        alias :sqs_message_id :request_id
        alias :sqs_sender_id :request_id
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

      def self.key_id(length=21)
        #Probably close enough
        Fog::Mock.random_selection('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',length)
      end

      def self.rds_address(db_name,region)
        "#{db_name}.#{Fog::Mock.random_letters(rand(12) + 4)}.#{region}.rds.amazonaws.com"
      end
    end
  end
end
