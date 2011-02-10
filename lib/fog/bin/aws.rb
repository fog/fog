class AWS < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::AWS::CDN
      when :compute, :ec2
        Fog::AWS::Compute
      when :dns
        Fog::AWS::DNS
      when :elb
        Fog::AWS::ELB
      when :iam
        Fog::AWS::IAM
      when :sdb, :simpledb
        Fog::AWS::SimpleDB
      when :ses
        Fog::AWS::SES
      when :eu_storage, :s3, :storage
        Fog::AWS::Storage
      else
        # @todo Replace most instances of ArgumentError with NotImplementedError
        # @todo For a list of widely supported Exceptions, see:
        # => http://www.zenspider.com/Languages/Ruby/QuickRef.html#35
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Fog::CDN.new(:provider => 'AWS')
        when :compute
          Fog::Compute.new(:provider => 'AWS')
        when :dns
          Fog::DNS.new(:provider => 'AWS')
        when :ec2
          location = caller.first
          warning = "[yellow][WARN] AWS[:ec2] is deprecated, use AWS[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Compute.new(:provider => 'AWS')
        when :elb
          Fog::AWS::ELB.new
        when :iam
          Fog::AWS::IAM.new
        when :eu_storage
          Fog::Storage.new(:provider => 'AWS', :region => 'eu-west-1')
        when :sdb, :simpledb
          Fog::AWS::SimpleDB.new
        when :ses
          Fog::AWS::SES.new
        when :s3
          location = caller.first
          warning = "[yellow][WARN] AWS[:s3] is deprecated, use AWS[:storage] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Storage.new(:provider => 'AWS')
        when :storage
          Fog::Storage.new(:provider => 'AWS')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::AWS.services
    end

  end
end
