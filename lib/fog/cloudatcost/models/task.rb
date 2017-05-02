module Fog
  module Compute
    class CloudAtCost
      class Task < Fog::Model
        identity :id
        attribute :cid
        attribute :idf
        attribute :serverid
        attribute :action
        attribute :status
        attribute :starttime
        attribute :finishtime
        attribute :servername
        attribute :ip
        attribute :label
        attribute :rdns
        attribute :rdnsdefault
      end
    end
  end
end
