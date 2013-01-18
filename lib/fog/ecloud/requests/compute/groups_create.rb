module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def groups_create(data)
          validate_data([:name], data)

          request(
            :body => generate_groups_create_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_groups_create_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateLayoutGroup(:name => data[:name]) do
            xml.Row(:href => data[:href], :name => data[:row_name], :type => "application/vnd.tmrk.cloud.layoutRow")
          end
        end
      end
    end
  end
end
