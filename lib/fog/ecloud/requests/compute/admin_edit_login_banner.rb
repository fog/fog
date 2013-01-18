module Fog
  module Compute
    class Ecloud
      class Real

        def login_banner_edit(data)
          validate_data([:display], data)
          body = build_login_banner_edit(data)
          request(
            :expects => 200,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        
        def build_login_banner_edit(data)
          xml = Builder::XmlMarkup.new
          xml.LoginBanner do
            xml.Display data[:display]
            xml.Text data[:text] if data[:text]
          end    
        end
      end
    end
  end
end
