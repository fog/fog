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
      when :sdb
        Fog::AWS::SimpleDB
      when :eu_storage, :s3, :storage
        Fog::AWS::Storage
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        klazz = class_for(key)
        hash[key] = case key 
        when :ec2
          location = caller.first
          warning = "[yellow][WARN] AWS[:ec2] is deprecated, use AWS[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          klazz.new
        when :eu_storage
          klazz.new(:region => 'eu-west-1')
        when :s3
          location = caller.first
          warning = "[yellow][WARN] AWS[:s3] is deprecated, use AWS[:storage] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          klazz.new
        else
          klazz.new
        end
      end
      @@connections[service]
    end

    def services
      [:cdn, :compute, :dns, :elb, :iam, :sdb, :storage]
    end

  end
end
