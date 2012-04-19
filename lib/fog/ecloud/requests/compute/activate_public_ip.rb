module Fog
  module Compute
    class Ecloud
      class Real
        def activate_public_ip(vdc_uri)
          request(
            :expects  => 200,
            :method   => 'POST',
            :uri      => vdc_uri,
            :parse    => true
          )
        end
      end

      class Mock

        #
        # Based on
        # http://support.theenterprisecloud.com/kb/default.asp?id=951&Lang=1&SID=
        #

        def activate_public_ip(vdc_uri, service_data)
          vdc_uri = ensure_unparsed(vdc_uri)

          if public_ip_collection = mock_data.public_ip_collection_from_href(vdc_uri)
            new_public_ip = MockPublicIp.new(public_ip_internet_service_collection)
            public_ip_collection.items << new_public_ip

            mock_it 200, xml, {'Content-Type' => 'application/vnd.tmrk.ecloud.publicIp+xml'}
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end
    end
  end
end
