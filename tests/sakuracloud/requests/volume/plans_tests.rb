# coding: utf-8
Shindo.tests('Fog::Volume[:sakuracloud] | list_plans request', ['sakuracloud', 'volume']) do

  @plan_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'Availability' => String
  }

  tests('success') do

    tests('#list_plans') do
      diskplans = volume_service.list_plans
      test 'returns a Hash' do
        diskplans.body.is_a? Hash
      end
      if Fog.mock?
        tests('DiskPlans').formats(@plan_format, false) do
          diskplans.body['DiskPlans'].first
        end
      else
        returns(200) { diskplans.status }
        returns(false) { diskplans.body.empty? }
      end
    end

  end

end
