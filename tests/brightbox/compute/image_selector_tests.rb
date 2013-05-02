Shindo.tests("Fog::Brightbox::Compute::ImageSelector.new", ["brightbox"]) do

  sample_images = [
    {
      "id" => "img-00000",
      "name" => "Ubuntu Lucid 10.04 LTS",
      "official" => true,
      "arch" => "i686",
      "created_at" => "2013-04-30T12:34:56"
    },
    {
      "id" => "img-11111",
      "name" => "ubuntu-precise-12.04-amd64-server",
      "official" => false,
      "arch" => "i686",
      "created_at" => "2013-05-01T12:34:56"
    },
    {
      "id" => "img-22222",
      "name" => "ubuntu-quantal-12.10-i386-server",
      "official" => true,
      "arch" => "i686",
      "created_at" => "2013-05-01T12:34:56"
    },
    {
      "id" => "img-33333",
      "name" => "ubuntu-raring-13.04-amd64-server",
      "official" => true,
      "arch" => "amd64",
      "created_at" => "2013-05-01T12:34:56"
    },
    {
      "id" => "img-44444",
      "name" => "Fedora 17 server",
      "official" => true,
      "arch" => "i686",
      "created_at" => "2013-05-01T12:34:56"
    },
    {
      "id" => "img-ubuntu",
      "name" => "ubuntu-raring-13.04-i386-server",
      "official" => true,
      "arch" => "i686",
      "created_at" => "2013-05-01T12:34:56"
    },
  ]

  @image_selector = Fog::Brightbox::Compute::ImageSelector.new(sample_images)

  test("#respond_to?(:latest_ubuntu)") do
    @image_selector.respond_to?(:latest_ubuntu)
  end

  tests("when there are sample of images") do
    tests("#latest_ubuntu").returns("img-ubuntu") do
      @image_selector.latest_ubuntu
    end
  end

  tests("when only old format names are present") do
    tests("#latest_ubuntu").returns("img-ubuntu") do
      sample_images = [
        {
          "id" => "img-11111",
          "name" => "Ubuntu Lucid 10.04 LTS server",
          "official" => true,
          "arch" => "i686",
          "created_at" => "2013-05-01T12:34:56"
        },
        {
          "id" => "img-22222",
          "name" => "Ubuntu Quantal 12.10 server",
          "official" => false,
          "arch" => "x86_64",
          "created_at" => "2013-05-01T12:34:56"
        },
        {
          "id" => "img-ubuntu",
          "name" => "Ubuntu Quantal 12.10 server",
          "official" => true,
          "arch" => "i686",
          "created_at" => "2013-05-01T12:34:56"
        },
        {
          "id" => "img-33333",
          "name" => "Blank disk image",
          "official" => true,
          "arch" => "i686",
          "created_at" => "2013-05-01T12:34:56"
        }
      ]
      @image_selector = Fog::Brightbox::Compute::ImageSelector.new(sample_images)
      @image_selector.latest_ubuntu

    end
  end

  tests("when ") do
    tests("#latest_ubuntu").returns(nil) do
      Fog::Brightbox::Compute::ImageSelector.new([]).latest_ubuntu
    end
  end
end
