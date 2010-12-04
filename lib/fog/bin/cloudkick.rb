class Cloudkick < Fog::Bin
  class << self

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :monitoring
          Fog::Cloudkick::Monitoring.new
        end
      end
      @@connections[service]
    end

    def services
      [:monitoring]
    end

    def account
      @@connections[:monitoring].account
    end

  end
end
