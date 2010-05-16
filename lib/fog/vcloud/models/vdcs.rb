module Fog
  module Vcloud
    class Mock
      def vdcs(options = {})
        @vdcs ||= Fog::Vcloud::Vdcs.new(options.merge(:connection => self))
      end
    end

    class Real
      def vdcs(options = {})
        @vdcs ||= Fog::Vcloud::Vdcs.new(options.merge(:connection => self))
      end
    end

    class Vdcs < Fog::Vcloud::Collection

      model Fog::Vcloud::Vdc

      get_request :get_vdc
      vcloud_type "application/vnd.vmware.vcloud.vdc+xml"
      all_request lambda { |vdcs| vdcs.connection.get_organization(vdcs.organization_uri) }

      def organization_uri
        @organizatio_uri ||= connection.default_organization_uri
      end

      private

      def organization_uri=(new_organization_uri)
        @organization_uri = new_organization_uri
      end

    end

  end
end
