require 'fog/core/model'

module Fog
  module Support
    class StormOnDemand
      class Ticket < Fog::Model
        identity :id
        attribute :accnt
        attribute :account
        attribute :body
        attribute :closed
        attribute :email
        attribute :handler
        attribute :last_responded
        attribute :received
        attribute :secid
        attribute :status
        attribute :subject
        attribute :type

        def initialize(attributes={})
          super
        end

        def add_feedback(options)
          requires :identity
          res = service.add_feedback({:id => identity}.merge!(options)).body
          res['feedback'].to_i == 1 ? true : false
        end

        def add_transaction_feedback(options)
          requires :identity
          requires :secid
          params = {:ticket_id => identity,
                    :secid => secid}.merge!(options)
          service.add_transaction_feedback(params).body
        end

        def authenticate(options)
          requires :identity
          requires :secid
          params = {:id => identity, :secid => secid}.merge!(options)
          service.authenticate(params).body
        end

        def close
          requires :identity
          requires :secid
          res = service.close_ticket(:id => identity, :secid => secid).body
          res['closed'].to_i == 1 ? true : false
        end

        def reopen
          requires :identity
          requires :secid
          res = service.reopen_ticket(:id => identity, :secid => secid).body
          res['reopened'].to_i == 1 ? true : false
        end

        def reply(options)
          requires :identity
          requires :secid
          res = service.reply_ticket({:id => identity,
                                      :secid => secid}.merge!(options)).body
          res['reply'].to_i == 1 ? true : false
        end
      end
    end
  end
end
