class GoGrid < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::GoGrid
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("GoGrid[:compute] is deprecated, use Compute[:gogrid] instead")
          Fog::Compute.new(:provider => 'GoGrid')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::GoGrid.services
    end

  end
end
