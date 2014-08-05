Shindo.tests('Fog::Compute[:google] | disk_type requests', ['google']) do
  @google = Fog::Compute[:google]

  @get_disk_type_format = {
    'name' => String,
    'kind' => String,
    'id' => Fog::Nullable::String,
    'creationTimestamp' => String,
    'deprecated' => Fog::Nullable::Array,
    'description' => String,
    'selfLink' => String,
    'validDiskSize' => String,
    'zone' => String,
  }

  @list_disk_types_format = {
    'kind' => String,
    'selfLink' => String,
    'items' => [@get_disk_type_format],
  }

  @list_aggregated_disk_types = {
    'kind' => String,
    'selfLink' => String,
    'items' => Hash,
  }

  tests('success') do

    tests('#list_aggregated_disk_types').formats(@list_aggregated_disk_types) do
      @google.list_aggregated_disk_types.body
    end

    tests('#list_disk_types').formats(@list_disk_types_format) do
      @google.list_disk_types('us-central1-a').body
    end

    tests('#get_disk_type').formats(@get_disk_type_format) do
      disk_type = @google.disk_types.first
      @google.get_disk_type(disk_type.identity, disk_type.zone).body
    end

  end

end
