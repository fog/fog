# coding: utf-8
Shindo.tests('Fog::Compute[:sakuracloud] | list_zones request', ['sakuracloud', 'compute']) do

  @zone_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'Description'  => String
  }

  tests('success') do

    tests('#list_zones') do
      zones = compute_service.list_zones
      test 'returns a Hash' do
        zones.body.is_a? Hash
      end
      if Fog.mock?
        tests('Zones').formats(@zone_format, false) do
          zones.body['Zones'].first
        end
      else
        returns(200) { zones.status }
        returns(false) { zones.body.empty? }
      end
    end

  end

end
