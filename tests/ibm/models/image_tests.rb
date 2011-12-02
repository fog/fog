Shindo.tests('Fog::Compute[:ibm] | image', ['ibm']) do

  @image_id = "20015393" 
  @image    = Fog::Compute[:ibm].images.get(@image_id)

  tests('success') do
             
  end
  
end