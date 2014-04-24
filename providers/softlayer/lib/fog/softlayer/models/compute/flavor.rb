#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
require 'fog/core/model'

module Fog
  module Compute
    class Softlayer

      class Flavor < Fog::Model

        identity :id

        attribute :cpu
        attribute :disk
        attribute :name
        attribute :ram

      end

    end
  end
end
