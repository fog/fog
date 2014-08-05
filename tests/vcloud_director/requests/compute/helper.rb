class VcloudDirector
  module Compute
    module Helper
      def self.test_name
        @test_name ||= 'fog-test-%x' % Time.now.to_i
      end

      def self.fixture(filename)
        File.join(File.expand_path('../../../fixtures', __FILE__), filename)
      end

      def self.current_org(service)
        service.get_organization(current_org_id(service)).body
      end

      def self.current_org_id(service)
        session = service.get_current_session.body
        link = session[:Link].find do |l|
          l[:type] == 'application/vnd.vmware.vcloud.org+xml'
        end
        link[:href].split('/').last
      end

      def self.first_vdc_id(org)
        link = org[:Link].find do |l|
          l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
        end
        link[:href].split('/').last
      end
    end
  end
end
