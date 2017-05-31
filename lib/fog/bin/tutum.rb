class Tutum < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Tutum
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                    when :compute
                      Fog::Compute.new(:provider => 'Tutum')
                    else
                      raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def services
      Fog::Tutum.services
    end
  end
end
