module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def rows_create(data)
          validate_data([:name], data)

          request(
            :body => generate_rows_create_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_rows_create_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateLayoutRow(:name => data[:name])
        end
      end
    end
  end
end
