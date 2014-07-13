Shindo.tests('Fog::Compute[:google] | disk requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_disk_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'zone' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_disk_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'zone' => String,
      'status' => String,
      'sizeGb' => String,
      'sourceImageId' => String,
      'sourceImage' => String,
      'type' => String,
  }

  @delete_disk_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'zone' => String,
      'startTime' => String,
      'operationType' => String
  }

  tests('success') do

    disk_name = 'new-disk-test'
    disk_size = '2'
    zone_name = 'us-central1-a'
    image_name = 'debian-7-wheezy-v20140408'

    # These will all fail if errors happen on insert
    tests("#insert_disk").formats(@insert_disk_format) do
      response = @google.insert_disk(disk_name, zone_name, image_name).body
      wait_operation(@google, response)
      response
    end

    tests("#get_disk").formats(@get_disk_format) do
      @google.get_disk(disk_name, zone_name).body
    end

    tests("#delete_disk").formats(@delete_disk_format) do
      @google.delete_disk(disk_name, zone_name).body
    end

  end

end
