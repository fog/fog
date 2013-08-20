require 'fog/core/model'

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

		def check_options(options)
        	if options[:type] == 'schedule'
        		args = options['args']
        		raise MissingArgumentException(self.name, "cron OR at") if args['cron'].nil? && args['at'].nil?
        	end
        	true
        end

      	def create(options)
          requires :name, :type, :cooldown

          check_options

          data = service.create_policy(group_id, options)
          merge_attributes(data.body['group'])
          true
        end

      	def update
      		requires :identity

      		options = {
      			'name' => name,
      			'change' => change,
      			'changePercent' => changePercent,
      			'cooldown' => cooldown,
      			'type' => type,
      			'args' => args,
      			'desiredCapacity' => desiredCapacity
      		}

      		data = service.update_policy(identity, options)
      		merge_attributes(data.body)
      		true
      	end

      	def destroy
      		requires :identity
      		service.delete_policy(identity)
      	end

      	def execute
      		requires :identity
      		service.execute_policy(identity)
      	end

      end
  	end
  end
end