Shindo.tests('Fog::Google[:monitoring] | metric_descriptor requests', ['google']) do
  @monitoring = Fog::Google[:monitoring]

  @get_metric_descriptor_format = {
    'name' => String,
    'description' => String,
    'labels' => Array,
    'project' => String,
    'typeDescriptor' => Hash,
  }

  @list_metric_descriptors_format = {
    'kind' => String,
    'metrics' => [@get_metric_descriptor_format],
  }

  tests('success') do

    tests('#list_metric_descriptors').formats(@list_metric_descriptors_format) do
      @monitoring.list_metric_descriptors.body
    end

  end

end
