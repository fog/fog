# coding: utf-8
Shindo.tests('Fog::Volume[:sakuracloud] | list_archives request', ['sakuracloud', 'volume']) do

  @archive_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'SizeMB'       => Integer,
    'Plan'         => Hash
  }

  tests('success') do

    tests('#list_archives') do
      archives = volume_service.list_archives
      test 'returns a Hash' do
        archives.body.is_a? Hash
      end
      if Fog.mock?
        tests('Archives').formats(@archive_format, false) do
          archives.body['Archives'].first
        end
      else
        returns(200) { archives.status }
        returns(false) { archives.body.empty? }
      end
    end

  end

end
