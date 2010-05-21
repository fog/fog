Shindo.tests('Slicehost#create_slice', 'slicehost') do
  tests('success') do

    tests("#create_slice(1, 19, 'fogcreateslice')").formats(Slicehost::Formats::SLICE.merge('root-password' => String)) do
      data = Slicehost[:slices].create_slice(1, 19, 'fogcreateslice').body
      @id = data['id']
      data
    end

    Fog.wait_for { Slicehost[:slices].get_slice(@id).body['status'] == 'active' }
    Slicehost[:slices].delete_slice(@id)

  end
end
