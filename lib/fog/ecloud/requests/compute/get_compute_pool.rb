module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_compute_pool
      end

      class Mock
        #
        #Based off of:
        #http://support.theenterprisecloud.com/kb/default.asp?id=567&Lang=1&SID=
        #

        def get_compute_pool(compute_pool_uri)
          compute_pool_uri = ensure_unparsed(compute_pool_uri)

          if compute_pool = mock_data.compute_pool_from_href(compute_pool_uri)
            xml = Builder::XmlMarkup.new
            mock_it 200,
              xml.ComputePool(:xmlns => "urn:tmrk:eCloudExtensions-2.8", :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                xml.Id compute_pool.object_id
                xml.Href compute_pool.href
                xml.Name compute_pool.name
                xml.State compute_pool.state
                xml.IsDefault compute_pool.is_default
              }, { 'Content-Type' => 'application/vnd.tmrk.ecloud.computePoolsList+xml' }
          else
            mock_error 200, "401 Unauthorized"
          end
        end

      end
    end
  end
end
