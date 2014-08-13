require 'securerandom'
Shindo.tests("Fog::Compute[:google] | image model", ['google']) do
  random_string = SecureRandom.hex
  source = 'https://www.google.com/images/srpr/logo4w.png'
  model_tests(Fog::Compute[:google].images, {:name => "fog-test-images-#{random_string}", "rawDisk" => { "source" => source } })
end
