class Glesys < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Glesys
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Formatador.display_line("[yellow][WARN] Glesys[:compute] is deprecated, use Compute[:glesys] instead[/]")
          Fog::Compute.new(:provider => 'Glesys')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Glesys.services
    end

  end
end
