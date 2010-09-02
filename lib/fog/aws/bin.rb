module AWS
  class << self
    credential = (ARGV.first && :"#{ARGV.first}") || :default
    if Fog.credentials[:aws_access_key_id] && Fog.credentials[:aws_secret_access_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :ec2
            Fog::AWS::EC2.new
          when :elb
            Fog::AWS::ELB.new
          when :simpledb
            Fog::AWS::SimpleDB.new
          when :s3
            Fog::AWS::S3.new
          end
        end
        @@connections[service]
      end

      for collection in Fog::AWS::EC2.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:ec2].#{collection}
          end
        EOS
      end

      for collection in Fog::AWS::S3.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:s3].#{collection}
          end
        EOS
      end

    else

      def initialized?
        false
      end

    end
  end

end
