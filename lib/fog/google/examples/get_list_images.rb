def test
  connection = Fog::Compute.new({ :provider => "Google" })

  # puts 'Listing images in all projects...'
  # puts '---------------------------------'
  images = connection.images.all
  raise 'Could not LIST the images' unless images
  # puts images.inspect

  # puts 'Fetching a single image from a global project...'
  # puts '------------------------------------------------'
  img = connection.images.get('debian-6-squeeze-v20130515')
  raise 'Could not GET the image' unless img
  # puts img.inspect

  # First, get the name of an image that is in the users 'project' (not global)
  custom_img_name = images.find { |img| img.project == img.service.project }
  # Run the next test only if there is a custom image available
  if custom_img_name
    # puts 'Fetching a single image from the custom project'
    # puts '----------------------------------------------'
    img = connection.images.get(custom_img_name.name)
    raise 'Could not GET the (custom) image' unless img
    # puts img.inspect
  end
end
