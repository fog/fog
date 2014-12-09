class Bluebox < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Bluebox
      when :dns
        Fog::DNS::Bluebox
      when :blb
        Fog::Bluebox::BLB
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Bluebox[:compute] is not recommended, use Compute[:bluebox] for portability")
          Fog::Compute.new(:provider => 'Bluebox')
        when :dns
          Fog::Logger.warning("Bluebox[:dns] is not recommended, use DNS[:bluebox] for portability")
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
