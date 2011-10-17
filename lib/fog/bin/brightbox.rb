class Brightbox < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Brightbox
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Brightbox[:compute] is deprecated, use Compute[:brightbox] instead")
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
