Shindo.tests('Fog::Compute[:gce] | image requests', ['gce']) do

  @gce = Fog::Compute[:gce]

  @insert_image_format = {
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

  @get_image_format = {
      'kind' => String,
      'id' => String,
      'creationTimestamp' => String,
      'selfLink' => String,
      'name' => String,
      'description' => String,
      'sourceType' => String,
      'preferredKernel' => String,
      'rawDisk' => {
        'containerType' => String,
        'source' => String
      }
  }

  @delete_image_format = {
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

  @list_images_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    image_name = 'ubuntu-12-04-v20120912'
    source_type = 'RAW'

    tests("#insert_image").formats(@insert_image_format) do
      @gce.insert_image(image_name, source_type).body
    end

    tests("#get_image").formats(@get_image_format) do
      @gce.get_image(image_name).body
    end

    tests("#list_images").formats(@list_images_format) do
      @gce.list_images.body
    end

    tests("#delete_image").formats(@delete_image_format) do
      @gce.delete_image(image_name).body
    end

  end

end
