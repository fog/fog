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
      'sizeGb' => String
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

  @list_disks_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => [{
        'kind'=> String,
        'id'=> String,
        'creationTimestamp'=>String,
        'selfLink'=>String,
        'name'=> String,
        'sizeGb'=> String,
        'zone'=> String,
        'status'=>String,
      }]
  }

  tests('success') do

    disk_name = 'fog-test-disk-' + Time.now.to_i.to_s
    disk_size = '2'
    zone_name = 'us-central1-a'
    image_name = 'debian-7-wheezy-v20131120'

    # These will all fail if errors happen on insert
    tests("#insert_disk").formats(@insert_disk_format) do
      operation = @google.insert_disk(disk_name, zone_name, image_name).body
      Fog.wait_for do
        operation = @google.get_zone_operation(operation['name'], operation['zone']).body
        operation['status'] == 'DONE'
      end
    end

    tests("#get_disk").formats(@get_disk_format) do
      @google.get_disk(disk_name, zone_name).body
    end

    tests("#list_disks").formats(@list_disks_format) do
      @google.list_disks(zone_name).body
    end

    tests("#delete_disk").formats(@delete_disk_format) do
      @google.delete_disk(disk_name, zone_name).body
    end

  end

end
