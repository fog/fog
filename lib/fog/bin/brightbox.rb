class Brightbox < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Brightbox::Compute
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Brightbox')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      [:compute]
    end

    def account
      @@connections[:compute].account
    end

  end
end
