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

      class Image < Fog::Model

        identity :id,               :aliases => 'globalIdentifier'
        attribute :name
        attribute :note
        attribute :parent_id,       :aliases => 'parentId'
        attribute :pulic_flag,      :aliases => 'publicFlag'
        attribute :status_id,       :aliases => 'statusId'
        attribute :summary
        attribute :transaction_id,  :aliases => 'transactionId'
        attribute :user_record_id,  :aliases => 'userRecordId'

      end

    end
  end
end
