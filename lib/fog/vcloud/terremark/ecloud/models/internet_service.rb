require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class InternetService < Fog::Vcloud::Model

          identity :href

          attribute :name
          attribute :id
          attribute :type
          attribute :protocol
          attribute :port
          attribute :enabled
          attribute :description
          attribute :public_ip
          attribute :timeout
          attribute :url_send_string
          attribute :http_header

        end
      end
    end
  end
end


