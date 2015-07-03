require 'fog/core/collection'
require 'fog/openstack/models/planning/plan'

module Fog
  module Openstack
    class Planning
      class Plans < Fog::Collection
        model Fog::Openstack::Planning::Plan

        def all(options = {})
          load(service.list_plans(options).body)
        end

        alias_method :summary, :all

        def find_by_uuid(plan_uuid)
          new(service.get_plan(plan_uuid).body)
        end
        alias_method :get, :find_by_uuid

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            self.all.find do |plan|
              plan.send($1) == arguments.first
            end
          else
            super
          end
        end
      end
    end
  end
end
