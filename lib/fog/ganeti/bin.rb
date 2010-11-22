class Ganeti < Fog::Bin
  class << self

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Ganeti::Compute.new
        when :ganeti
          location = caller.first
          warning = "[yellow][WARN] Ganeti[:ganeti] is deprecated, use Ganeti[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Ganeti::Compute.new
        end
      end
      @@connections[service]
    end

    def services
      [:compute]
    end

  end
end
