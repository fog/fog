class Ovirt < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Ovirt
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                    when :compute
                      Fog::Compute.new(:provider => 'Ovirt')
                    else
                      raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def services
      Fog::Ovirt.services
    end
  end
end
