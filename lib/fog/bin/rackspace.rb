class Rackspace < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::CDN::Rackspace
      when :compute
        Fog::Compute::Rackspace
      when :storage
        Fog::Storage::Rackspace
      when :load_balancers
        Fog::Rackspace::LoadBalancers
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Formatador.display_line("[yellow][WARN] Rackspace[:cdn] is deprecated, use CDN[:rackspace] instead[/]")
          Fog::CDN.new(:provider => 'Rackspace')
        when :compute
          Formatador.display_line("[yellow][WARN] Rackspace[:compute] is deprecated, use Compute[:rackspace] instead[/]")
          Fog::Compute.new(:provider => 'Rackspace')
        when :dns
          Fog::DNS.new(:provider => 'Rackspace')
        when :load_balancers
          Fog::Rackspace::LoadBalancers.new
        when :storage
          Formatador.display_line("[yellow][WARN] Rackspace[:storage] is deprecated, use Storage[:rackspace] instead[/]")
          Fog::Storage.new(:provider => 'Rackspace')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Rackspace.services
    end

  end
end
