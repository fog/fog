# StormOnDemand services examples

This storm_on_demand directory provides code for all storm on demand cloud APIs. All of the APIs are seperated into Compute, Network, Storage, DNS, Monitoring, Account, Billing, Support and Billing services.


## Use a service
Before using APIs of a service, you need to create a service object first. Take Compute for instance:

		c = Fog::Compute.new :provider => :stormondemand,
							 :storm_on_demand_username => 'username',
							 :storm_on_demand_password => 'password'
Now, you can call API methods for Compute service. For instance:

		c.servers.all
this will list all servers for the current account.

## Call an API method
According to Fog, a high level interface is provided through collections, such as images and servers. Each collection has a corresponding model, such as image and server.

APIs like create, list or details reside in the collections. For instance:

		server = c.servers.create :config_id => conf.id,
								  :template => tpl.name,
								  :domain => 'example.com',
								  :password => 'rootpassword'
Other APIs for specific cloud object will reside in a model. For instance:

		server.reboot :force => 1

All APIs' parameters are the same with the [Storm On Demand API Doc](https://www.stormondemand.com/api/docs/v1/).

#### (p.s. In order to conform to Fog's CRUD operations, some API methods are changed. For instance, 'list' methods are now 'all', 'details' methods are now 'get')


## Use a Token
If you want to use a token instead of password for API calls, instead of creating a new service like Compute, you should create a new Account first and get the token. Then create a new Compute/Network/Storage with the token.

		account = Fog::Account.new :provider => :stormondemand,
								   :storm_on_demand_username => 'username',
							       :storm_on_demand_password => 'password'
		# create a new token
		token = account.tokens.create
		# use the token instead of a password
		net = Fog::Network.new :provider => :stormondemand,
							   :storm_on_demand_username = 'username',
							   :storm_on_demand_password = token.token
		
		# if you want to expire the token
		token.expire
