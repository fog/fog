class Glesys < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Glesys
      when :storage
        Fog::Storage::Glesys
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Formatador.display_line("[yellow][WARN] Glesys[:compute] is deprecated, use Compute[:Glesys] instead[/]")
          Fog::Compute.new(:provider => 'Glesys')
        when :storage
          Formatador.display_line("[yellow][WARN] Glesys[:storage] is deprecated, use Storage[:Glesys] instead[/]")
          Fog::Storage.new(:provider => 'Glesys')
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
