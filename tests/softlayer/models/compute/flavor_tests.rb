#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

Shindo.tests("Fog::Compute[:softlayer] | Flavor model", ["softlayer"]) do

  tests("success") do

    @service = Fog::Compute[:softlayer]

    tests("#all") do
      returns(Fog::Compute::Softlayer::Flavor) { @service.flavors.all.first.class }
    end

    tests("#get") do
      returns(Fog::Compute::Softlayer::Flavor) { @service.flavors.get('m1.tiny').class }
    end

  end
end

