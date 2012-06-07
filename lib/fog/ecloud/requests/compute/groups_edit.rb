module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def groups_edit(data)
          validate_data([:name], data)

          request(
            :body => generate_groups_edit_request(data),
            :expects => 204,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => false
          )
        end

        private

        def generate_groups_edit_request(data)
          xml = Builder::XmlMarkup.new
          xml.LayoutGroup(:name => data[:name])
        end
      end
    end
  end
end
