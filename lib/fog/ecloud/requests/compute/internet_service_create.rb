module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_internet_service_data(service_data)
          required_opts = [:name, :protocol, :port, :description, :enabled, :persistence]
          unless required_opts.all? { |opt| service_data.has_key?(opt) }
            raise ArgumentError.new("Required Internet Service data missing: #{(required_opts - service_data.keys).map(&:inspect).join(", ")}")
          end
          if service_data[:trusted_network_group]
            raise ArgumentError.new("Required Trusted Network Group data missing: #{([:name, :href] - service_data[:trusted_network_group].keys).map(&:inspect).join(", ")}")
          end
          if service_data[:backup_internet_service]
            raise ArgumentError.new("Required Backup Internet Service data missing: #{([:name, :href] - service_data[:backup_internet_service].keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def internet_service_create(service_data)
          validate_internet_service_data(service_data)

          request(
            :body => generate_internet_service_request(service_data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => service_data[:uri],
            :parse => true
          )
        end

        private

        def generate_internet_service_request(service_data)
          xml = Builder::XmlMarkup.new
          xml.CreateInternetService(:name => service_data[:name]) do
            xml.Protocol service_data[:protocol]
            xml.Port service_data[:port]
            xml.Enabled service_data[:enabled]
            xml.Description service_data[:description]
            xml.Persistence do
              xml.Type service_data[:persistence][:type]
              if service_data[:persistence][:timeout]
                xml.Timeout service_data[:persistence][:timeout]
              end
            end
            if service_data[:redirect_url]
              xml.RedirectUrl service_data[:redirect_url]
            end
            if service_data[:trusted_network_group]
              xml.TrustedNetworkGroup(:href => service_data[:trusted_network_group][:href], :name => service_data[:trusted_network_group][:name], :type => 'application/vnd.tmrk.cloud.trustedNetworkGroup')
            end
            if service_data[:backup_internet_service]
              xml.BackupInternetService(:href => service_data[:backup_internet_service][:href], :name => service_data[:backup_internet_service][:name], :type => 'application/vnd.tmrk.cloud.backupInternetService')
            end
            if service_data[:load_balancing_method]
              xml.LoadBalancingMethod service_data[:load_balancing_method]
            end
          end
        end
      end
    end
  end
end          
