class Fogdocker < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Fogdocker
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                    when :compute
                      Fog::Compute.new(:provider => 'Fogdocker')
                    else
                      raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def services
      Fog::Fogdocker.services
    end
  end
end
