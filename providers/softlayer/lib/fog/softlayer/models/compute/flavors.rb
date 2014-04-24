#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
require 'fog/core/collection'
require 'fog/softlayer/models/compute/flavor'

module Fog
  module Compute
    class Softlayer

      ## SoftLayer doesn't actually have "flavors", these are just for portability/convenience,
      # they map directly to OpenStack defaults.


      # :cores => number of virtual CPUs presented
      # :disk  => size in GB of the virtual root disk
      # :ram   => virtual machine memory in MB
      FLAVORS = [
          {
              :id                      => 'm1.tiny',
              :name                    => 'Tiny Instance',
              :cpu                     => 2,
              :disk                    => [{'device' => 0, 'diskImage' => {'capacity' => 25 } }],
              :ram                     => 1024
          },
          {
              :id                      => 'm1.small',
              :name                    => 'Small Instance',
              :cpu                     => 2,
              :disk                    => [{'device' => 0, 'diskImage' => {'capacity' => 100 } }],
              :ram                     => 2048
          },
          {
              :id                      => 'm1.medium',
              :name                    => 'Medium Instance',
              :cpu                     => 4,
              :disk                    => [{'device' => 0, 'diskImage' => {'capacity' => 500 } }],
              :ram                     => 4096
          },
          {
              :id                      => 'm1.large',
              :name                    => 'Large Instance',
              :cpu                     => 8,
              :disk                    => [{'device' => 0, 'diskImage' => {'capacity' => 750 } }],
              :ram                     => 8192
          },
          {
              :id                      => 'm1.xlarge',
              :name                    => 'Extra Large Instance',
              :cpu                     => 16,
              :disk                    => [{'device' => 0, 'diskImage' => {'capacity' => 1000 } }],
              :ram                     => 16384
          }
      ]

      class Flavors < Fog::Collection

        model Fog::Compute::Softlayer::Flavor

        # Returns an array of all flavors that have been created
        #
        # Fog::Softlayer.flavors.all
        def all
          load(Fog::Compute::Softlayer::FLAVORS)
          self
        end

        # Used to retrieve a flavor
        # flavor_id is required to get the associated flavor information.
        # flavors available currently:
        #
        # m1.tiny
        #
        # You can run the following command to get the details:
        # Softlayer.flavors.get("m1.tiny")
        #
        # ==== Returns
        #
        #>> Softlayer.flavors.get("m1.tiny")
        # <Fog::Softlayer::Compute::Flavor
        #  id="m1.tiny",
        #  cores=1,
        #  disk=160,
        #  name="Tiny Instance",
        #  ram=1024
        # >
        #

        def get(flavor_id)
          self.class.new(:service => service).all.detect {|flavor| flavor.id == flavor_id}
        end

      end

    end
  end
end
