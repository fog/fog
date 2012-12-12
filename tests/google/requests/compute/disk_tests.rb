Shindo.tests('Fog::Compute[:google] | disk requests', ['gce']) do

  @google = Fog::Compute[:gce]

  @insert_disk_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
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
      'startTime' => String,
      'operationType' => String
  }

  @list_disks_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    disk_name = 'new-disk-test'
    disk_size = '2'

    tests("#insert_disk").formats(@insert_disk_format) do
      @google.insert_disk(disk_name, disk_size).body
    end

    tests("#get_disk").formats(@get_disk_format) do
      @google.get_disk(disk_name).body
    end

    tests("#list_disks").formats(@list_disks_format) do
      @google.list_disks.body
    end

    tests("#delete_disk").formats(@delete_disk_format) do
      @google.delete_disk(disk_name).body
    end

  end

end
