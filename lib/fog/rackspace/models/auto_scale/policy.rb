require 'fog/core/model'
require 'fog/rackspace/models/auto_scale/webhooks'

module Fog
  module Rackspace
    class AutoScale
      class Policy < Fog::Model

      	identity :id

      	attribute :group_id

      	attribute :links
      	attribute :name
      	
      	# integer
      	attribute :change
      	attribute :changePercent

      	# integer
      	attribute :cooldown

      	# webhook|schedule|cloud_monitoring
      	attribute :type

      	# hash depending on the type chosen
     		#	- "cron": "23 * * * *"
     		#	- "at": "2013-06-05T03:12Z"
     		#	- "check": {
    		# 	      "label": "Website check 1",
    		# 	      "type": "remote.http",
    		# 	      "details": {
    		# 	          "url": "http://www.example.com",
    		# 	          "method": "GET"
    		# 	      },
    		# 	      "monitoring_zones_poll": [
    		# 	          "mzA"
    		# 	      ],
    		# 	      "timeout": 30,
    		# 	      "period": 100,
    		# 	      "target_alias": "default"
    		# 	  },
    		# 	  "alarm_criteria": {
    		# 	       "criteria": "if (metric[\"duration\"] >= 2) { return new AlarmStatus(OK); } return new AlarmStatus(CRITICAL);"
    		# 	  }
      	attribute :args

      	attribute :desiredCapacity

		    def check_attributes
          raise MissingArgumentException(self.name, type) if type.nil?

        	if type == 'schedule'
        		raise MissingArgumentException(self.name, "args[cron] OR args[at]") if args['cron'].nil? && args['at'].nil?
        	end

        	true
        end

      	def save
          requires :name, :type, :cooldown

          check_attributes

          options = {}
          options['name'] = name unless name.nil?
          options['change'] = change unless change.nil?
          options['changePercent'] = changePercent unless changePercent.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['type'] = type unless type.nil?
          options['desiredCapacity'] = desiredCapacity unless desiredCapacity.nil?

          if type == 'schedule'
            options['args'] = args
          end

          data = service.create_policy(group_id, options)
          true
        end

      	def update
      		requires :identity

          check_attributes

      		options = {}
          options['name'] = name unless name.nil?
          options['change'] = change unless change.nil?
          options['changePercent'] = changePercent unless changePercent.nil?
          options['cooldown'] = cooldown unless cooldown.nil?
          options['type'] = type unless type.nil?
          options['desiredCapacity'] = desiredCapacity unless desiredCapacity.nil?

          if type == 'schedule'
            options['args'] = args
          end

      		data = service.update_policy(group_id, identity, options)
      		merge_attributes(data.body)
      		true
      	end

      	def destroy
      		requires :identity
      		service.delete_policy(group_id, identity)
          true
      	end

      	def execute
      		requires :identity
      		service.execute_policy(group_id, identity)
          true
      	end

        def webhooks
          data = service.list_webhooks(group_id, self.id)

          Fog::Rackspace::AutoScale::Webhooks.new({
            :service   => service,
            :policy_id => self.id,
            :group_id  => group_id
          }).merge_attributes(data.body)
        end

      end
  	end
  end
end