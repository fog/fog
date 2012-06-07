module Fog
  module Compute
    class Ecloud
      class Real

        def authentication_levels_edit(data)
          validate_data([:basic, :sha1, :sha256, :sha512], data)
          body = build_authentication_levels_edit(data)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        
        def build_authentication_levels_edit(data)
          xml = Builder::XmlMarkup.new
          xml.AuthenticationLevels do
            xml.BasicEnabled data[:basic]
            xml.SHA1Enabled data[:sha1]
            xml.SHA256Enabled data[:sha256]
            xml.SHA512Enabled data[:sha512]
          end    
        end
      end
    end
  end
end
