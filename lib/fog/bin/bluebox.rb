class Bluebox < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Bluebox
      when :dns
        Fog::DNS::Bluebox
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Bluebox[:compute] is deprecated, use Compute[:bluebox] instead")
          Fog::Compute.new(:provider => 'Bluebox')
        when :dns
          Fog::Logger.warning("Bluebox[:storage] is deprecated, use Storage[:bluebox] instead")
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
