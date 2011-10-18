require 'fog/core/model'

module Fog
  module Compute
    class Ninefold

      class Flavor < Fog::Model

        identity :id

        attribute :cpunumber
        attribute :cpuspeed
        attribute :created, :type => :time
        attribute :displaytext
        attribute :domain
        attribute :domainid
        attribute :hosttags
        attribute :memory
        attribute :name
        attribute :offerha
        attribute :storagetype
        attribute :tags


      end

    end
  end
end
