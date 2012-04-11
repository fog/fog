module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_compute_pools
      end

      class Mock
        #
        # Based off of:
        # http://support.theenterprisecloud.com/kb/default.asp?id=577&Lang=1&SID=
        #

        def get_compute_pools(compute_pools_uri)
          compute_pools_uri = ensure_unparsed(compute_pools_uri)

          if compute_pool_collection = mock_data.compute_pool_collection_from_href(compute_pools_uri)
            xml = Builder::XmlMarkup.new
            mock_it 200,
              xml.ComputePools {
                compute_pool_collection.items.each do |cp|
                  xml.ComputePool {
                    xml.Id cp.object_id
                    xml.Href cp.href
                    xml.Name cp.name
                    xml.State cp.state
                    xml.IsDefault cp.is_default
                  }
                end
              }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.computePoolsList+xml'}
          else
            mock_error 200, "401 Unauthorized"
          end
        end

      end
    end
  end
end
