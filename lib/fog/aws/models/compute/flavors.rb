require 'fog/core/collection'
require 'fog/aws/models/compute/flavor'

module Fog
  module Compute
    class AWS

      FLAVORS = [
        { :bits => 0,  :cores =>   2,  :disk => 0,    :id =>  't1.micro',   :name => 'Micro Instance',       :ram => 613},

        { :bits => 32, :cores =>   1,  :disk => 160,  :id =>  'm1.small',   :name => 'Small Instance',       :ram => 1740.8},
        { :bits => 64, :cores =>   4,  :disk => 850,  :id =>  'm1.large',   :name => 'Large Instance',       :ram => 7680},
        { :bits => 64, :cores =>   8,  :disk => 1690, :id =>  'm1.xlarge',  :name => 'Extra Large Instance', :ram => 15360},

        { :bits => 32, :cores =>   5,  :disk => 350,  :id =>  'c1.medium',  :name => 'High-CPU Medium',      :ram => 1740.8},
        { :bits => 64, :cores =>  20,  :disk => 1690, :id =>  'c1.xlarge',  :name => 'High-CPU Extra Large', :ram => 7168},

        { :bits => 64, :cores =>  6.5, :disk => 420,  :id =>  'm2.xlarge',  :name => 'High-Memory Extra Large',           :ram => 17510.4},
        { :bits => 64, :cores =>   13, :disk => 850,  :id =>  'm2.2xlarge', :name => 'High Memory Double Extra Large',    :ram => 35020.8},
        { :bits => 64, :cores =>   26, :disk => 1690, :id =>  'm2.4xlarge', :name => 'High Memory Quadruple Extra Large', :ram => 70041.6},

        { :bits => 64, :cores => 33.5, :disk => 1690, :id => 'cc1.4xlarge', :name => 'Cluster Compute Quadruple Extra Large', :ram => 23552},
        { :bits => 64, :cores => 33.5, :disk => 1690, :id => 'cg1.4xlarge', :name => 'Cluster GPU Quadruple Extra Large',     :ram => 22528}
      ]

      class Flavors < Fog::Collection

        model Fog::Compute::AWS::Flavor

        # Returns an array of all flavors that have been created
        #
        # AWS.flavors.all
        #
        # ==== Returns
        #
        # Returns an array of all available instance sizes
        #
        #>> AWS.flavors.all
        #  <Fog::AWS::Compute::Flavors
        #    [
        #      <Fog::AWS::Compute::Flavor
        #        id="t1.micro",
        #        bits=0,
        #        cores=2,
        #        disk=0,
        #        name="Micro Instance",
        #        ram=613
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.small",
        #        bits=32,
        #        cores=1,
        #        disk=160,
        #        name="Small Instance",
        #        ram=1740.8
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.large",
        #        bits=64,
        #        cores=4,
        #        disk=850,
        #        name="Large Instance",
        #        ram=7680
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.xlarge",
        #        bits=64,
        #        cores=8,
        #        disk=1690,
        #        name="Extra Large Instance",
        #        ram=15360
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="c1.medium",
        #        bits=32,
        #        cores=5,
        #        disk=350,
        #        name="High-CPU Medium",
        #        ram=1740.8
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="c1.xlarge",
        #        bits=64,
        #        cores=20,
        #        disk=1690,
        #        name="High-CPU Extra Large",
        #        ram=7168
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.xlarge",
        #        bits=64,
        #        cores=6.5,
        #        disk=420,
        #        name="High-Memory Extra Large",
        #        ram=17510.4
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.2xlarge",
        #        bits=64,
        #        cores=13,
        #        disk=850,
        #        name="High Memory Double Extra Large",
        #        ram=35020.8
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.4xlarge",
        #        bits=64,
        #        cores=26,
        #        disk=1690,
        #        name="High Memory Quadruple Extra Large",
        #        ram=70041.6
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="cc1.4xlarge",
        #        bits=64,
        #        cores=33.5,
        #        disk=1690,
        #        name="Cluster Compute Quadruple Extra Large",
        #        ram=23552
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="cg1.4xlarge",
        #        bits=64,
        #        cores=33.5,
        #        disk=1690,
        #        name="Cluster GPU Quadruple Extra Large",
        #        ram=22528
        #      >
        #    ]
        #  >
        #

        def all
          load(Fog::Compute::AWS::FLAVORS)
          self
        end

        # Used to retreive a flavor
        # flavor_id is required to get the associated flavor information.
        # flavors available currently:
        # 't1.micro', 'm1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.xlarge', 'm2.2xlarge', 'm2.4xlarge', 'cc1.4xlarge', 'cg1.4xlarge'
        #
        # You can run the following command to get the details:
        # AWS.flavors.get("t1.micro")
        #
        # ==== Returns
        #
        #>> AWS.flavors.get("t1.micro")
        # <Fog::AWS::Compute::Flavor
        #  id="t1.micro",
        #  bits=0,
        #  cores=2,
        #  disk=0,
        #  name="Micro Instance",
        #  ram=613
        #>
        #

        def get(flavor_id)
          self.class.new(:connection => connection).all.detect {|flavor| flavor.id == flavor_id}
        end

      end

    end
  end
end
