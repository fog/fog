class Clodo < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Clodo
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Formatador.display_line("[yellow][WARN] Clodo[:compute] is deprecated, use Compute[:clodo] instead[/]")
          Fog::Compute.new(:provider => 'Clodo')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Clodo.services
    end
  end
end
