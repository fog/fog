require 'fog/collection'
require 'fog/aws/models/ec2/flavor'

module Fog
  module AWS
    module EC2

      class Mock
        def flavors
          Fog::AWS::EC2::Flavors.new(:connection => self)
        end
      end

      class Real
        def flavors
          Fog::AWS::EC2::Flavors.new(:connection => self)
        end
      end

      class Flavors < Fog::Collection

        model Fog::AWS::EC2::Flavor

        def all
          data = [
            { :bits => 32, :cores => 1, :disk => 160,  :id => 'm1.small',  :name => 'Small Instance',       :ram => 1740.8},
            { :bits => 64, :cores => 4, :disk => 850,  :id => 'm1.large',  :name => 'Large Instance',       :ram => 7680},
            { :bits => 64, :cores => 8, :disk => 1690, :id => 'm1.xlarge', :name => 'Extra Large Instance', :ram => 15360},

            { :bits => 32, :cores =>  5, :disk => 350,  :id => 'c1.medium', :name => 'High-CPU Medium',      :ram => 1740.8},
            { :bits => 64, :cores => 20, :disk => 1690, :id => 'c1.xlarge', :name => 'High-CPU Extra Large', :ram => 7168},

            { :bits => 64, :cores => 13, :disk => 850,  :id => 'm2.2xlarge', :name => 'High Memory Double Extra Large',    :ram => 35020.8},
            { :bits => 64, :cores => 26, :disk => 1690, :id => 'm2.4xlarge', :name => 'High Memory Quadruple Extra Large', :ram => 70041.6},
          ]
          load(data)
          self
        end

        def get(flavor_id)
          all.detect {|flavor| flavor.id == flavor_id}
        end

      end

    end
  end
end
