module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_operating_system_families
      end

      class Mock
        def get_operating_system_families(uri)
          compute_pool_id = id_from_uri(uri)
          compute_pool    = self.data[:compute_pools][compute_pool_id]

          operating_system_families = self.data[:operating_system_families].values.select{|osf| osf[:compute_pool_id] == compute_pool_id}
          operating_system_families = operating_system_families.map{|osf| Fog::Ecloud.slice(osf, :id, :compute_pool_id)}.map{|osf| osf[:OperatingSystemFamily]}

          operating_system_family_response = {:OperatingSystemFamily => (operating_system_families.size > 1 ? operating_system_families : operating_system_families.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.operatingSystemFamily; type=collection",
            :Links => {
              :Link => compute_pool,
            }
          }.merge(operating_system_family_response)

          response(:body => body)
        end
      end
    end
  end
end
