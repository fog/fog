Shindo.tests("Fog::Compute[:openstack] | images collection", ['openstack']) do

  tests('success') do

    tests('#all').succeeds do
      fog = Fog::Compute[:openstack]
      test 'not nil' do
        fog.images.all.is_a? Array
      end
    end

  end
end
