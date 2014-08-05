module Fog
  module Compute
    class Ecloud
      class SupportTicket < Fog::Ecloud::Model
        identity :href

        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :date, :aliases => :Date
        attribute :status, :aliases => :Status
        attribute :category, :aliases => :Category
        attribute :detected_by, :aliases => :DetectedBy
        attribute :severity, :aliases => :Severity
        attribute :device, :aliases => :Device
        attribute :classification, :aliases => :Classification
        attribute :owner, :aliases => :Owner
        attribute :description, :aliases => :Description
        attribute :information, :aliases => :Information
        attribute :solution, :aliases => :Solution
        attribute :history, :aliases => :History

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
