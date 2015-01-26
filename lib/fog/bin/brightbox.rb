class Brightbox < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Brightbox
      when :storage
        Fog::Storage::Brightbox
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Brightbox[:compute] is not recommended, use Compute[:brightbox] for portability")
          Fog::Compute.new(:provider => 'Brightbox')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def account
      @@connections[:compute].account
    end

    def services
      Fog::Brightbox.services
    end
  end
end
