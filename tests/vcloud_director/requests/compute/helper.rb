class VcloudDirector
  module Compute
    module Helper

      def self.current_org(service)
        session = service.get_current_session.body
        link = session[:Link].detect do |l|
          l[:type] == 'application/vnd.vmware.vcloud.org+xml'
        end
        service.get_organization(link[:href].split('/').last).body
      end

    end
  end
end
