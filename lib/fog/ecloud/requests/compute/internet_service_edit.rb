module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_edit_internet_service_options(options)
          required_opts = [:name, :enabled, :persistence]
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
          raise ArgumentError.new("Required data missing: #{:persistence[:type]}") unless options[:persistence][:type]
        end

        def build_node_service_body_edit(options)
          xml = Builder::XmlMarkup.new
          xml.InternetService(:name => options[:name]) do
            xml.Enabled options[:enabled]
            if options[:description]
              xml.Description options[:description]
            end
            xml.Persistence do
              xml.Type options[:persistence][:type]
              if options[:persistence][:timeout]
                xml.Timeout options[:persistence][:timeout]
              end
            end
            if options[:redirect_url]
              xml.RedirectUrl options[:redirect_url]
            end
            if options[:trusted_network_group]
              xml.TrustedNetworkGroup(:href => options[:trusted_network_group][:href], :name => service_data[:trusted_network_group][:name], :type => 'application/vnd.tmrk.cloud.trustedNetworkGroup')
            end
            if options[:backup_internet_service]
              xml.BackupInternetService(:href => options[:backup_internet_service][:href], :name => service_data[:backup_internet_service][:name], :type => 'application/vnd.tmrk.cloud.backupInternetService')
            end
            if options[:load_balancing_method]
              xml.LoadBalancingMethod options[:load_balancing_method]
            end
          end    
        end
      end

      class Real

        def node_service_edit(options)
          validate_edit_node_service_options(options)
          body = build_node_service_body_edit(options)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => options[:uri],
            :parse => true
          )
        end
      end
    end
  end
end
