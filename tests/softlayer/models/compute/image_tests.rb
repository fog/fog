#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

Shindo.tests("Fog::Compute[:softlayer] | Image model", ["softlayer"]) do
  pending if Fog.mocking?
  tests("success") do

    @service = Fog::Compute[:softlayer]

    tests("#all") do
      @image = @service.images.all.first
      returns(Fog::Compute::Softlayer::Image) { @image.class }
    end

    tests("#get") do
      returns(Fog::Compute::Softlayer::Image) { @service.images.get(@image.id).class }
    end

  end
end

