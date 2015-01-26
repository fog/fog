Shindo.tests('Fog::Compute[:google] | image requests', ['google']) do

  @google = Fog::Compute[:google]

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
      'items' => [@get_image_format]
  }

  tests('success') do

    random_string = SecureRandom.hex
    image_name = "fog-test-image-#{random_string}"
    source = 'https://www.google.com/images/srpr/logo4w.png'

    tests("#insert_image").formats(@insert_image_format) do
      pending if Fog.mocking?
      response = @google.insert_image(image_name, 'rawDisk' => source).body
      wait_operation(@google, response)
      response
    end

    tests("#get_image").formats(@get_image_format) do
      pending if Fog.mocking?
      @google.get_image(image_name).body
    end

    tests("#list_images").formats(@list_images_format) do
      @google.list_images.body
    end

    tests("#delete_image").formats(@delete_image_format) do
      pending if Fog.mocking?
      @google.delete_image(image_name).body
    end

  end

end
