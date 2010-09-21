class AWS < Fog::Bin
  class << self

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::AWS::Compute.new
        when :ec2
          location = caller.first
          warning = "[yellow][WARN] AWS[:ec2] is deprecated, use AWS[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::AWS::Compute.new
        when :elb
          Fog::AWS::ELB.new
        when :simpledb
          Fog::AWS::SimpleDB.new
        when :s3
          location = caller.first
          warning = "[yellow][WARN] AWS[:s3] is deprecated, use AWS[:storage] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::AWS::Storage.new
        when :storage
          Fog::AWS::Storage.new
        end
      end
      @@connections[service]
    end

    def services
      [:compute, :elb, :simpledb, :storage]
    end

  end
end
