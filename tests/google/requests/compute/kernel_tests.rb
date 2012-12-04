Shindo.tests('Fog::Compute[:google] | kernel requests', ['gce']) do

  @google = Fog::Compute[:gce]

  @get_kernel_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'description' => String
  }

  @list_kernels_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    tests("#get_kernel").formats(@get_kernel_format) do
      kernel_name = @google.list_kernels.body["items"][0]["name"]
      @google.get_kernel(kernel_name).body
    end

    tests("#list_kernels").formats(@list_kernels_format) do
      @google.list_kernels.body
    end

  end

end
