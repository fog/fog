require 'fog/core/model'

module Fog
  module Compute
    class Ninefold

      class Image < Fog::Model

        identity :id

        attribute :account
        attribute :accountid
        attribute :bootable
        attribute :created, :type => :time
        attribute :crossZones
        attribute :displaytext
        attribute :domain
        attribute :domainid
        attribute :format
        attribute :hypervisor
        attribute :isextractable
        attribute :isfeatured
        attribute :ispublic
        attribute :isready
        attribute :jobid
        attribute :jobstatus
        attribute :name
        attribute :ostypeid
        attribute :ostypename
        attribute :passwordenabled
        attribute :removed
        attribute :size
        attribute :status
        attribute :templatetype
        attribute :zoneid
        attribute :zonename

      end

    end
  end
end
