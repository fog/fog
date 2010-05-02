module AWS
  class << self
    credential = (ARGV.first && :"#{ARGV.first}") || :default
    if Fog.credentials[:aws_access_key_id] && Fog.credentials[:aws_secret_access_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k, v|
            ![:aws_access_key_id, :aws_secret_access_key].include?(k)
          end
          hash[key] = case key
          when :ec2
            Fog::AWS::EC2.new(credentials)
          when :elb
            Fog::AWS::ELB.new(credentials)
          when :simpledb
            Fog::AWS::SimpleDB.new(credentials)
          when :s3
            Fog::AWS::S3.new(credentials)
          end
        end
        @@connections[service]
      end

      def addresses
        self[:ec2].addresses
      end

      def directories
        self[:s3].directories
      end

      def flavors
        self[:ec2].flavors
      end

      def images
        self[:ec2].images
      end

      def servers
        self[:ec2].servers
      end

      def key_pairs
        self[:ec2].key_pairs
      end

      def security_groups
        self[:ec2].security_groups
      end

      def snapshots
        self[:ec2].snapshots
      end

      def volumes
        self[:ec2].volumes
      end

    else

      def initialized?
        false
      end

    end
  end
end
