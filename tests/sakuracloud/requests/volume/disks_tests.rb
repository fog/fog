# coding: utf-8
Shindo.tests('Fog::Volume[:sakuracloud] | list_disks request', ['sakuracloud', 'volume']) do

  @disks_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'Connection'   => String,
    'Availability' => String,
    'SizeMB'       => Integer,
    'Plan'         => Hash
  }

  tests('success') do

    tests('#list_disks') do
      disks = volume_service.list_disks
      test 'returns a Hash' do
        disks.body.is_a? Hash
      end
      if Fog.mock?
        tests('Disks').formats(@disks_format, false) do
          disks.body['Disks'].first
        end
      else
        returns(200) { disks.status }
        returns(true) { disks.body.is_a? Hash }
      end
    end
  end
end

Shindo.tests('Fog::Volume[:sakuracloud] | create_disks request', ['sakuracloud', 'volume']) do
  tests('success') do
    tests('#create_disks') do
      disks = volume_service.create_disk('foobar', 4, 112500463685)
      test 'returns a Hash' do
        disks.body.is_a? Hash
      end

      unless Fog.mock?
        returns(202) { disks.status }
        returns(true) { disks.body.is_a? Hash }
      end
    end
  end
end
