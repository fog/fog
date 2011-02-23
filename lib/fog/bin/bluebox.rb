class Bluebox < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Bluebox::Compute
      when :dns
        Fog::Bluebox::DNS
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Bluebox')
        when :dns
          Fog::DNS.new(:provider => 'Bluebox')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Bluebox.services
    end

  end
end
