module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_ssh_keys
      end

      class Mock
        def get_ssh_keys(uri)
          organization_id = id_from_uri(uri)
          organization    = self.data[:organizations][organization_id]

          ssh_keys = self.data[:ssh_keys].values.select{|key| key[:admin_organization_id] == organization_id}
          ssh_keys = ssh_keys.map{|key| Fog::Ecloud.slice(key, :id, :admin_organization)}

          ssh_key_response = {:SshKey => (ssh_keys.size > 1 ? ssh_keys : ssh_keys.first)} # GAH
          body = {
            :href  => "/cloudapi/ecloud/admin/organizations/#{organization_id}/sshKeys",
            :type  => "application/vnd.tmrk.cloud.sshKey; type=collection",
            :Links => {
              :Link => organization,
            },
          }.merge(ssh_key_response)

          response(:body => body)
        end
      end
    end
  end
end
