Shindo.tests('Fog::Compute::RackspaceV2 | images', ['rackspace']) do
  service = Fog::Compute::RackspaceV2.new

  image_id = nil

  tests("success") do
    tests("#all").succeeds do
      images = service.images.all
      image_id = images.first.id
    end

    tests("#get").succeeds do
      service.images.get(image_id)
    end
  end

  tests("failure").returns(nil) do
    service.images.get(Fog::Rackspace::MockData::NOT_FOUND_ID)
  end
end
