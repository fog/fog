class Linode < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Linode
      when :dns
        Fog::DNS::Linode
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Formatador.display_line("[yellow][WARN] Linode[:compute] is deprecated, use Compute[:linode] instead[/]")
          Fog::Compute.new(:provider => 'Linode')
        when :dns
          Formatador.display_line("[yellow][WARN] Linode[:storage] is deprecated, use Storage[:linode] instead[/]")
          Fog::DNS.new(:provider => 'Linode')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Linode.services
    end

  end
end
