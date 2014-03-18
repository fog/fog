module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def backup_internet_service_create(data)
          validate_data([:name, :protocol, :enabled, :persistence], data)
          unless data[:persistence][:type]
            raise ArgumentError.new("Required data missing: :persistence[:type]")
          end

          request(
            :body => generate_backup_internet_service_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_backup_internet_service_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateBackupInternetService(:name => data[:name]) do
            xml.Protocol data[:protocol]
            xml.Enabled data[:enabled]
            if data[:description]
              xml.Description data[:description]
            end
            xml.Persistence do
              xml.Type data[:persistence][:type]
              if data[:persistence][:timeout]
                xml.Timeout data[:persistence][:timeout]
              end
            end
            if data[:redirect_url]
              xml.RedirectUrl data[:redirect_url]
            end
          end
        end
      end
    end
  end
end
