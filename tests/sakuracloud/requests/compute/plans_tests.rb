# coding: utf-8
Shindo.tests('Fog::Compute[:sakuracloud] | list_plans request', ['sakuracloud', 'compute']) do

  @plan_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'CPU'          => Integer,
    'MemoryMB'     => Integer,
    'Availability' => String
  }

  tests('success') do

    tests('#list_plans') do
      serverplans = compute_service.list_plans
      test 'returns a Hash' do
        serverplans.body.is_a? Hash
      end
      if Fog.mock?
        tests('ServerPlans').formats(@plan_format, false) do
          serverplans.body['ServerPlans'].first
        end
      else
        returns(200) { serverplans.status }
        returns(false) { serverplans.body.empty? }
      end
    end

  end

end
