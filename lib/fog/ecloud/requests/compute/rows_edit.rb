module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def rows_edit(data)
          validate_data([:name], data)

          request(
            :body => generate_rows_edit_request(data),
            :expects => 204,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => false
          )
        end

        private

        def generate_rows_edit_request(data)
          xml = Builder::XmlMarkup.new
          xml.LayoutRow(:name => data[:name])
        end
      end
    end
  end
end
