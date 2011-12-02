class IBM < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::IBM
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'IBM')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::IBM.services
    end

  end
end
