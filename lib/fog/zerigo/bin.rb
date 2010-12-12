class Zerigo < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Zerigo::Compute
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = class_for(key).new
      end
      @@connections[service]
    end

    def services
      [:compute]
    end

  end
end
