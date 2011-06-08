class Ninefold < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Ninefold::Compute
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Ninefold')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Ninefold.services
    end

  end
end
