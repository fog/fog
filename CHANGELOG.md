## 2.2.0 06/18/2019
*Hash* 198649965a63fea6296831689cadda2c06570840

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1534
Open Issues   | 4
Watchers      | 4215

**MVP!** Conor Tinch

#### [misc]
*   Removed all references to fog-cloudstack. Fog-cloudstack can be added back into lib/fog/bin.rb once we have a fog-cloudstack gem. thanks Conor Tinch
*   Added cloudstack in as a provider since there's a gem. thanks Conor Tinch
*   Added cloudstack in as a provider since there's a gem. thanks Conor Tinch
*   remove fog-joyent from gemspec, at least temporarily. thanks geemus
*   bump fog-core version. thanks geemus


## 2.1.0 11/12/2018
*Hash* adc3d36e1c47976a1ec2630bd4577e082593c884

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1545
Open Issues   | 7
Watchers      | 4168

**MVP!** Akira Matsuda

#### [cloudstack]
*   Allow specifying the size of root volume. thanks Takashi Kokubun

#### [misc]
*   GitHub is https by default. thanks Akira Matsuda
*   Remove BlueBox Blocks. thanks Chris Lundquist
*   Add SemVer stability badge to README. thanks Grey Baker
*   Upgrade google dependency. thanks Nat Welch
*   Fix whitespace in gemspec. thanks Nat Welch
*   unpin mime-types. thanks Nat Welch
*   Removing leftovers from extraction of fog-ovirt. thanks Ori Rabin
*   Make CloudSigma snapshot tests pending. thanks Paul Thornthwaite
*   Rescue `opennebula` loading issues. thanks Paul Thornthwaite
*   "Fix" incorrect `Compute` provider credential test. thanks Paul Thornthwaite
*   Tweak CloudSigma testing schema. thanks Paul Thornthwaite
*   Fix Cloudstack `#connection` deprecation warning. thanks Paul Thornthwaite
*   Remove tests for deprecated binary `#[]`. thanks Paul Thornthwaite
*   Enable Ruby 2.5 in CI. thanks Pavel Valena
*   lib/fog/linode: Add Tokyo2 to avail_datacenters. thanks Penny
*   Fix compatibility with fog-brightbox 1.0.0+. thanks t Ondruch
*   v2.0.0. thanks geemus
*   add stale bot config. thanks geemus
*   remove tests around deprecated usage. thanks geemus


## 2.0.0 03/06/2018
*Hash* ff9fe270cd23627f748dd37e9bf2800640187f60

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1553
Open Issues   | 41
Watchers      | 4102

**MVP!** Tinguely Pierre

#### [misc]
*   Drop Zerigo. thanks Paulo Ribeiro
*   add id in xml only if present. Else an id is generated from xsd generation. thanks Tinguely Pierre
*   make network optionnal for instantiate request. thanks Tinguely Pierre
*   implement the put api to configure the network section in vapp. thanks Tinguely Pierre
*   Drop Ruby<2 support. thanks Tomer Brisker
*   bump rubocop dep. thanks geemus


## 1.42.0 09/29/2017
*Hash* 41a38068d34237b9639ac045f99a4b48160834a9

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1556
Open Issues   | 45
Watchers      | 4060

**MVP!** swamp09

#### [misc]
*   Upgrade JSON to ~> 2.0. thanks Denis Defreyne
*   Removing ovirt provider. thanks Ori Rabin
*   fix changelog task. thanks geemus
*   Suppress `warning: ambiguous first argument; put parentheses or a space even after `/' operator`. thanks swamp09
*   Suppress `warning: mismatched indentations at 'end' with 'class'`. thanks swamp09


## 1.41.0 08/01/2017
*Hash* e5d3672e804149d38f91ccdfdaf7cfd7be52b75b

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1558
Open Issues   | 44
Watchers      | 4042

**MVP!** effeminate-batman

#### [misc]
*   Attach ovirt activate and deactivate volume calls that are available in the rbovirt library. thanks  Felix
*   Remove internet_archive. thanks Nat Welch
*   add fog-internet-archive to deps. thanks Nat Welch
*   sort dependency list. thanks Nat Welch
*   Remove more internet archive stuff. thanks Nat Welch
*   Re-add internet_archive. thanks Nat Welch
*   Add 2.3 and 2.4 to test builds, also trusty. thanks Nat Welch
*   Joyent Extraction. thanks effeminate-batman
*   Add Joyent to fog.gemspec. thanks effeminate-batman
*   bump fog-core. thanks geemus
*   allow dash in committer name for changelog. thanks geemus
*   adding disks and clone to attribute. thanks orrabin

#### [ovirt]
*   fix waiting for VM to be stopped. thanks as


## 1.40.0 03/13/2017
*Hash* ed5edd8610f5585267f07567cccec1c10b002764

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1556
Open Issues   | 48
Watchers      | 3975


#### [misc]
*   bump fog-digitalocean version to avoid conflict. thanks geemus


## 1.39.0 03/13/2017
*Hash* d6c89ea01e747f36e3d384191ac3072e29ddec64

Statistic     | Value
------------- | --------:
Collaborators | 2
Forks         | 1556
Open Issues   | 48
Watchers      | 3975

**MVP!** Cherdancev Evgeni

#### [CloudSigma]
*   add snapshots (#3491). thanks zephyrean

#### [digitalocean]
*   delete leftover spec. thanks geemus

#### [misc]
*   Adding postinstall message. thanks Artem Yakimenko
*   Fixing gemspec conflicts with 1.9. thanks Artem Yakimenko
*   Add instance_types support to oVirt provider. thanks Baptiste Agasse
*   Fix filtering for Digital Ocean list_ssh_keys request. thanks Ben Sedat
*   Allow filtering for Digital Ocean list_flavors request. thanks Ben Sedat
*   Fix Digital Ocean list_servers mock format. thanks Ben Sedat
*   Add tests for Digital Ocean list_ssh_keys request. thanks Ben Sedat
*   Digital Ocean list_* requests pass query params to Excon. thanks Ben Sedat
*   add suspend&resume support and change tests to fog way. thanks Cherdancev Evgeni
*   remove execute flag from README.md. thanks Cherdancev Evgeni
*   retab & remove empty Mock. thanks Cherdancev Evgeni
*   change tests for using fogtest flavor. thanks Cherdancev Evgeni
*   add suspend&resume support and change tests to fog way. thanks Cherdancev Evgeni
*   remove execute flag from README.md. thanks Cherdancev Evgeni
*   retab & remove empty Mock. thanks Cherdancev Evgeni
*   change tests for using fogtest flavor. thanks Cherdancev Evgeni
*   Prevent malformed request with asterisk (*) character. thanks Gavin Lam
*   Add DigitalOcean provider. thanks  Garcia
*   Removed 'filters' from ssh_key. thanks JJ Asghar
*   extract DNSimple, require 'fog-dnsimple'. thanks Joshua Lane
*   remove dnsimple tests. thanks Joshua Lane
*   remove ninefold. thanks Joshua Lane
*   Fix default API version for Joyent. thanks Manuel Franco
*   fix dependency issues when building on 1.9.*. thanks Paulo Ribeiro
*   Add request to create snapshot. thanks Pierre Tinguely
*   #3900 Escape VM name in OpenNebula allocator. thanks Sergey Susikov
*   Remove digitalocean. thanks Suraj Shirvankar
*   Remove digitalocean bin files. thanks Suraj Shirvankar
*   Total number of droplets for digital ocean. thanks Tameem
*   Add more changes. thanks Tameem
*   Testing. thanks Tameem
*   Working. thanks Tameem
*   clean. thanks Tameem
*   F rage4 bulk update endpoint (#3917). thanks Tameem Iftikhar
*   Drop 'hp' from compute tests. thanks t Ondruch
*   Drop 'hp' from storage tests. thanks t Ondruch
*   Drop 'hp' test cases. thanks t Ondruch
*   bump fog-core dep. thanks geemus
*   bump fog-core dependency. thanks geemus
*   fix fog-core dependency. thanks geemus
*   bump fog-core dep. thanks geemus
*   remove require for missing digitalocean bin. thanks geemus
*   Update licence.md. thanks pieceofcakeresul
*   Update compose_common.rb. thanks tinguelyp
*   Update post_create_snapshot.rb. thanks tinguelyp


## 1.38.0 03/28/2016
*Hash* 5e4bde2733adc08ba2d92b2d2824e2d3845fc5e5

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 14820336
Forks         | 1539
Open Issues   | 58
Watchers      | 3805

**MVP!** Daniel Aragao

#### [DigitalOcean]
*   - Failed requests fail to log because of Bluebox. thanks Daniel Lobato

#### [HPCloud]
*   Removing HP cloud. thanks JJ Asghar

#### [digitalocean]
*   fix method sig for list_images mock. thanks geemus
*   update flavor tests to match v2 mock. thanks geemus

#### [docker]
*   Fixing bad namespace on errors. thanks David Davis

#### [misc]
*   support neutron networks labled as public. thanks Chris McClimans
*   rfc1918 addys for private_address. thanks  Emilie
*   merging. thanks Dan Aragao
*   fixing bad merge. thanks Dan Aragao
*   this doesn't seem to exist anymore. thanks Dan Aragao
*   Task to run vcloud-director tests only. thanks Daniel Aragao
*   Adding Syslog config elements to org network. thanks Daniel Aragao
*   Revert "Adding Syslog config elements to org network.". thanks Daniel Aragao
*   Adds VPN section to edge gateway service configuration. thanks Daniel Aragao
*   Adds DHCP to edge gateway service configuration. thanks Daniel Aragao
*   Fixes attributes when generating xml body for post deploy vapps. thanks Daniel Aragao
*   Add post compose vapp to requests. thanks Daniel Aragao
*   Add post compose vapp to requests. thanks Daniel Aragao
*   The AdminPassword XML element isn't present unless AdminPasswordEnabled, maybe because it's an empty tag? If not set the VCloud API gives a 400. thanks Daniel Aragao
*   WIP - Complying with VCloud Director's xml and pulling it into its own class with tests. thanks Daniel Aragao
*   AllEULAsAccepted has to be in the right 'place', adding VM name and escape customisation scripts. thanks Daniel Aragao
*   Once more, order matters. thanks Daniel Aragao
*   WIP - Complying with VCloud Director's xml and pulling it into its own class with tests. thanks Daniel Aragao
*   AllEULAsAccepted has to be in the right 'place', adding VM name and escape customisation scripts. thanks Daniel Aragao
*   Once more, order matters. thanks Daniel Aragao
*   The AdminPassword XML element isn't present unless AdminPasswordEnabled, maybe because it's an empty tag? If not set the VCloud API gives a 400. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   I need the network name too. thanks Daniel Aragao
*   I need the network name too. thanks Daniel Aragao
*   Fix from closed PR #2967. thanks Daniel Aragao
*   Changed my mind on this one and closed off PR #2967. thanks Daniel Aragao
*   WIP - Adding post recompose vapp. Hacky for now. thanks Daniel Aragao
*   Better to pass the VM model instead of a random hash. thanks Daniel Aragao
*   Power off leaves it in 'Partially Running' state. VMs must be fully OFF when deleting them with recompose. thanks Daniel Aragao
*   InstantiationParams and SourceItems are only needed when actually adding VMs. thanks Daniel Aragao
*   Easier to read. thanks Daniel Aragao
*   Adding 'deployed' status to model so that one can decide whether to undeploy. thanks Daniel Aragao
*   Revert "Fix from closed PR #2967". thanks Daniel Aragao
*   Refactoring to remove duplication from compose and recompose generators. thanks Daniel Aragao
*   Wrong merge. thanks Daniel Aragao
*   Ignoring this for now. thanks Daniel Aragao
*   Housekeeping. thanks Daniel Aragao
*   WIP - Adding post recompose vapp. Hacky for now. thanks Daniel Aragao
*   Better to pass the VM model instead of a random hash. thanks Daniel Aragao
*   Power off leaves it in 'Partially Running' state. VMs must be fully OFF when deleting them with recompose. thanks Daniel Aragao
*   InstantiationParams and SourceItems are only needed when actually adding VMs. thanks Daniel Aragao
*   Easier to read. thanks Daniel Aragao
*   Adding 'deployed' status to VM model. thanks Daniel Aragao
*   Housekeeping. thanks Daniel Aragao
*   Refactoring to remove duplication from compose and recompose generators. thanks Daniel Aragao
*   Don't try to build it if it doesn't exist. thanks Daniel Aragao
*   Oops. thanks Daniel Aragao
*   Adding missing tags for NetworkConnection. thanks Daniel Aragao
*   Adding missing tags for NetworkConnection. thanks Daniel Aragao
*   Adding tests for vm and vms parsers. These represent the XML crunching from GET requests in compute. thanks Daniel Aragao
*   Adding tests for vm and vms parsers. These represent the XML crunching from GET requests in compute. thanks Daniel Aragao
*   Adding 'deployed' status to model so that one can decide whether to undeploy. thanks Daniel Aragao
*   For the old versions of Ruby. thanks Daniel Aragao
*   For the old versions of Ruby. thanks Daniel Aragao
*   Fixing dependency in Travis. thanks Daniel Aragao
*   Fixing dependency in Travis. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   I need the network name too. thanks Daniel Aragao
*   Revert "Fix from closed PR #2967". thanks Daniel Aragao
*   Adding tests for vm and vms parsers. These represent the XML crunching from GET requests in compute. thanks Daniel Aragao
*   Adding 'deployed' status to model so that one can decide whether to undeploy. thanks Daniel Aragao
*   For the old versions of Ruby. thanks Daniel Aragao
*   Fixing dependency in Travis. thanks Daniel Aragao
*   Task to run vcloud-director tests only. thanks Daniel Aragao
*   Adding Syslog config elements to org network. thanks Daniel Aragao
*   Revert "Adding Syslog config elements to org network.". thanks Daniel Aragao
*   Adds VPN section to edge gateway service configuration. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   I need the network name too. thanks Daniel Aragao
*   Changed my mind on this one and closed off PR #2967. thanks Daniel Aragao
*   Adding 'deployed' status to model so that one can decide whether to undeploy. thanks Daniel Aragao
*   Wrong merge. thanks Daniel Aragao
*   Don't try to build it if it doesn't exist. thanks Daniel Aragao
*   Oops. thanks Daniel Aragao
*   Adding tests for vm and vms parsers. These represent the XML crunching from GET requests in compute. thanks Daniel Aragao
*   For the old versions of Ruby. thanks Daniel Aragao
*   Fixing dependency in Travis. thanks Daniel Aragao
*   Adding network_adapters to VM parser and model as a single IP address doesn't cut when dealing with multiple networks. thanks Daniel Aragao
*   DRYer refactored version. thanks Daniel Aragao
*   Adding tests for vm and vms parsers. These represent the XML crunching from GET requests in compute. thanks Daniel Aragao
*   For the old versions of Ruby. thanks Daniel Aragao
*   Standardize the `:state` alias to `:status`. thanks JJ Asghar
*   Keeping the dependency gems in order. thanks JJ Asghar
*   Move Rackspace out to provider gem. thanks Matt Darby
*   Removed bulk of OpenStack. thanks Matt Darby
*   openstack service retrieval also pass options on unscoped fallback. thanks Maurice Schreiber
*   openstack image v2 correct images find_by_* and find_attribute. thanks Maurice Schreiber
*   Removes URI::encode call on parameteres. thanks Petr Blaho
*   Added filtering capabilities to images request. thanks Raul Roa
*   Added filtering capabilities to servers request. thanks Raul Roa
*   Added filtering capabilities to regions request. thanks Raul Roa
*   Adding myself to the contributors list. thanks Raul Roa
*   Added missing argument for regions request. thanks Raul Roa
*   Updated list_regions signature at Mock. thanks Raul Roa
*   Updated list_servers signature at Mock. thanks Raul Roa
*   Put the prefix in place for all identity calls. thanks Sean Handley
*   Include endpoint path matcher. thanks Sean Handley
*   Deperate delete_server for destroy_server. thanks Suraj Shirvankar
*   Added rake task to install the gem locally. thanks Suraj Shirvankar
*   Added the cloudatcost as a gem. thanks Suraj Shirvankar
*   Delete stuff. thanks Suraj Shirvankar
*   Update README.md. thanks Suraj Shirvankar
*   Remove more hp remains. thanks Suraj Shirvankar
*   Added paging for images collection. thanks Suraj Shirvankar
*   Removed debug code. thanks Suraj Shirvankar
*   Change method from dig to deep fetch. thanks Suraj Shirvankar
*   Add get_server_password functionality. thanks Tareq
*   Strip port number from host header. thanks Tim Lawrence
*   Added label to Guest Properties. thanks Tim Lawrence
*   require builder. thanks Tim Lawrence
*   Added instantiate_vapp_template_params generator. thanks Tim Lawrence
*   Tidying up for PR. thanks Tim Lawrence
*   Tidying up for PR. thanks Tim Lawrence
*   Tidying up for PR. thanks Tim Lawrence
*   pin mime-types version. thanks Tim Lawrence
*   add spec helper with creds. thanks Tim Lawrence
*   fix tests. thanks Tim Lawrence
*   Revert "[digitalocean] update flavor tests to match v2 mock". thanks geemus
*   cleanup some HP remnants. thanks geemus
*   remove old test running stuff for extracted providers. thanks geemus
*   rework mock openstack snapshot to have same behavior as servers... thanks zhitongLBN
*   use symbol to fix get options erreur. thanks zhitongLBN
*   added associate and disassociate into floating_ip objet     make mock requests concern floating_ips to have same behaviors as     compute's. thanks zhitongLIU

#### [openstack]
*   storage does not require api_key and username, token can also be used. thanks Andreas Pfau

#### [skip ci]
*   Fix some typos in the README. thanks Tim Wade

#### [vcloud director]
*   access vApp Template Virtual Machines from Catalog Items. thanks Tim Lawrence

#### [vcloud_director]
*   fix typo for port omission. thanks Wesley Beary


## 1.37.0 12/22/2015
*Hash* f7cf6b7c6499ab2a58bb7fe6848363d7cc459d3a

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 13380838
Forks         | 1530
Open Issues   | 89
Watchers      | 3729

**MVP!** Rich Daley

#### [misc]
*   Remove vSphere provider. thanks  Garcia
*   Remove lib/fog/bin/vsphere. thanks  Garcia
*   Use fog-vsphere ~> 0.2. thanks  Garcia
*   OpenStack fix Cinder v2 typo. thanks Ladislav Smola
*   OpenStack add server evacuate action. thanks Ladislav Smola
*   Fix DigitalOceanV2::SshKey misplaced #save, #destroy and #update methods. thanks Manuel Franco
*   Enforce no slash in container name. thanks Matt Darby
*   Update API path for deleting SSH keys. thanks Michael Borohovski
*   Upgrade version of fog-vsphere to 0.4. Fixes #3784. thanks Michael Borohovski
*   Updates Getting Started for DigitalOcean. thanks Peter Souter
*   Add some mocks for VM (partial) and Network. thanks Rich Daley
*   Add loads more mocks to the vcloud_director backend. thanks Rich Daley
*   Add mocks for disks. thanks Rich Daley
*   Add mock support for tags. thanks Rich Daley
*   Don't pass AdminPassword if AdminPasswordAuto is true (causes an exception). thanks Rich Daley
*   Remove erroneous file. thanks Rich Daley
*   Add a barebones :post_reconfigure_vm and a Vm#reconfigure that uses it. thanks Rich Daley
*   Add a mock and fix infinite loop issue. thanks Rich Daley
*   Set description in the mocks ahead of separate PR. thanks Rich Daley
*   Add support for VM descriptions. thanks Rich Daley
*   Add a #storage_only to disks to return only those disks that are actually disks. thanks Rich Daley
*   Remove description if it hasn't changed. thanks Rich Daley
*   Make comment more explicit about OVF. thanks Rich Daley
*   Add vdc.networks. thanks Rich Daley
*   Fix bogus requires. thanks Rich Daley
*   Add a mock for put_network_connection_system_section_vapp and fix the mock for get_vm_network to get the VM ID the same way the parser does. thanks Rich Daley
*   Add mock for post_power_on_vapp. thanks Rich Daley
*   Add mock for delete_vapp. thanks Rich Daley
*   According to doc, only the username is mandatory. thanks Sean Handley
*   If the management URL has no path, use the one in the auth URI. thanks Sean Handley
*   Revert "If the management URL has no path, use the one in the auth URI.". thanks Sean Handley
*   Workaround for installs using both v2 and v3. thanks Sean Handley
*   Fix #3785 Missing image details for digitalocean version 2 api. thanks Suraj Shirvankar
*   Added method locked? to check if the machine is currently locked with     another operation. thanks Suraj Shirvankar
*   Add openstack_temp_url_key to the list of recognized options. thanks Yauheni Kryudziuk
*   rely on fog-xml nokogiri dep. thanks geemus
*   add mime-types as dev dependency. thanks geemus
*   Update compute.md. thanks losingle

#### [openstack]
*   volume API v2 implementation. thanks Darren Hague
*   Revert over-eager optimisation in v2 authentication case. thanks Darren Hague

#### [rackspace]
*   Add support for get_vnc_console request to compute_v2. thanks Dusty Jones


## 1.36.0 11/16/2015
*Hash* e7cd19696284633d4363993e2e3fda41384b7d58

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 12793379
Forks         | 1517
Open Issues   | 92
Watchers      | 3689

**MVP!** Phil Ross

#### [misc]
*   added content-encoding meta-data. thanks ller
*   version for fog-aliyun added in fog.gemspec. thanks Daniyal Shah
*   Digital Ocean V2 call to create an ssh key returns a 201 on success: https://developers.digitalocean.com/documentation/v2/#create-a-new-key. thanks Dave Benvenuti
*   improve mocks to more closely match real ssh key endpoint functionality. thanks Dave Benvenuti
*   Fix issue when creating virtual machines with more than 7 disks. thanks Francois Herbert
*   Fix distributed port group switches support for cloning with multiple networks. thanks as
*   Extract virtualswitch parameter to the network model. thanks as
*   fix openstack baremetal node delete. thanks Jason Montleon
*   Fixed issue with OpenStack Auth v2. thanks ller
*   Fix set node type for Rackspace load balancer. thanks Pablo Porto
*   Add abbr attribute to Linode DataCenter. thanks Phil Ross
*   Add created_at and requires_pvops_kernel to Linode Image model. thanks Phil Ross
*   Update the Linode avail_kernels request and Kernel model. thanks Phil Ross
*   Update the Linode avail_linodeplans request and Flavor model. thanks Phil Ross
*   Add support for the Linode avail.nodebalancers API call. thanks Phil Ross
*   Fix the signature of the Linode avail_stackscripts mock. thanks Phil Ross
*   Use options on the all method to filter Linode kernels. thanks Phil Ross
*   fix method call name in openstack node destroy so that it will work. thanks Stephen Herr
*   vsphere: allow setting of boot order when using api > 5.0. thanks Timo Goebel
*   Revert "temporarily relax ruby version constraint". thanks geemus
*   make net/ssh require optional. thanks geemus
*   re-add 1.9 to travis config. thanks geemus
*   limit to 1.9 compat fog-google. thanks geemus
*   1.8 compatibility for pre 2 release. thanks geemus

#### [openstack]
*   Basic caching support for auth tokens, domains & projects. thanks Darren Hague
*   Re-record VCRs, plus some light refactoring. thanks Darren Hague

#### [vsphere]
*   add support for taking snapshot. thanks Ivo Reznicek
*   support for snapshot list and revert. thanks Ivo Reznicek
*   support for listing processes in guest OS. thanks Ivo Reznicek
*   Prefer Class#name to Class#to_s. thanks Kevin Menard


## 1.35.0 10/20/2015
*Hash* 4444f3287454a4281ead73fa24aa1b93d5d23a39

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 12346569
Forks         | 1496
Open Issues   | 86
Watchers      | 3665

**MVP!** bryanl

#### [#3099]
*   Remove Nokogiri constraint. thanks Paul Thornthwaite

#### [Fog 2.0]
*   Remove 1.8.7 support. thanks Paul Thornthwaite
*   Update docs re dropping 1.8.7 support. thanks Paul Thornthwaite

#### [misc]
*   Add boot_volume_size to RS compute_v2 Server Create. thanks Alain De Carolis
*   fix kernel selection bug. thanks Alex Borisov
*   Use head version of all released MRI versions. thanks Caleb Thompson
*   Allow travis to generate matrix of rubies and gems. thanks Caleb Thompson
*   Re-add 1.9.3 support. thanks Caleb Thompson
*   Allow failures on latest Ruby version. thanks Caleb Thompson
*   change get_raw replacement regex from />/ to /=>/ for output XML. thanks Cherdancev Evgeni
*   add RAW tests. thanks Cherdancev Evgeni
*   fixing scope of mock class on compute_v2 digital ocean list fiels. thanks Joshua Gross
*   Fixing misnaming of methods for mock classes in compute v2 digitalocean. thanks Joshua Gross
*   Making the existing suite of tests pass for digitalocean compute v2. thanks Joshua Gross
*   fixing digitalocean server tests to test response format. thanks Joshua Gross
*   fixing merge conflicts. thanks Joshua Gross
*   forgetful save of a file. thanks Joshua Gross
*   Openstack adding Heat Patch support. thanks Ladislav Smola
*   Openstack volumes adding volume type management. thanks Ladislav Smola
*   Ensure root user behaves like Rackspace defaults. thanks Martin Smith
*   Require fog-google versions compatable w/ > 1.9.3. thanks Nat Welch
*   update fog-google dep to > 0.1.1. thanks Nat Welch
*   Added case to reboot gracefully if toolsOld. thanks Nick Huanca
*   Change URL options to a hash rather than an array. thanks Paul Martin
*   CGI.escape and character replacements. thanks Paul Martin
*   Limit 1.9.3 tests to use older Net::SSH. thanks Paul Thornthwaite
*   Remove support for Ruby 1.9.3. thanks Paul Thornthwaite
*   Don't allow Travis failures for Ruby 2.2. thanks Paul Thornthwaite
*   Removed unecessary configurations from Travis. thanks Paulo Henrique Lopes Ribeiro
*   Bumped required ruby version to 1.9.3. thanks Paulo Henrique Lopes Ribeiro
*   Remove XENSERVER code. thanks Paulo Henrique Lopes Ribeiro
*   Remove XENSERVER tests. thanks Paulo Henrique Lopes Ribeiro
*   Remove XENSERVER bin. thanks Paulo Henrique Lopes Ribeiro
*   Remove XENSERVER test helper. thanks Paulo Henrique Lopes Ribeiro
*   Depend on fog-xenserver. thanks Paulo Henrique Lopes Ribeiro
*   Adds documentation for new V2 methods. thanks Peter Souter
*   Add new #get method for images. thanks Peter Souter
*   Adds #transfer and #convert methods to image. thanks Peter Souter
*   list_servers. thanks bryanl
*   list_images. thanks bryanl
*   list_regions. thanks bryanl
*   list_flavors. thanks bryanl
*   add a server mock. thanks bryanl
*   list_servers. thanks bryanl
*   list_images. thanks bryanl
*   list_regions. thanks bryanl
*   list_flavors. thanks bryanl
*   add a server mock. thanks bryanl
*   add create and delete server. thanks bryanl
*   get a server. thanks bryanl
*   add droplet actions. thanks bryanl
*   add ssh key data. thanks bryanl
*   support DigitalOcean v2 compute API. thanks bryanl
*   add methods for server ipv4 and ipv6 public addresses. thanks bryanl
*   Fog support new provider: aliyun. thanks dengqinsi
*   v2.0.0.pre.0. thanks geemus
*   temporarily relax ruby version constraint. thanks geemus

#### [openstack]
*   Add request for Cinder to get quota usage. thanks Dang Tung Lam
*   List server actions fix. thanks Dang Tung Lam
*   Glance v2 API. thanks Darren Hague
*   Make sure that Identity v3 authentication uses a v3 endpoint. thanks Darren Hague
*   IdV3: re-record VCRs against a new DevStack kilo installation. thanks Darren Hague


## 1.34.0 09/03/2015
*Hash* 23467f391cbc9d8d3262da33cec533f8b8e80cee

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 11446261
Forks         | 1472
Open Issues   | 82
Watchers      | 3594

**MVP!** Oleg Vivtash

#### [Brightbox]
*   Remove provider specific tests. thanks Paul Thornthwaite

#### [OpenStack]
*   Enable list_snapshots_detailed request. thanks Greg Blomquist

#### [misc]
*   Adding #get_by_id for Fog::Compute::VcloudDirector::VmCustomizations. thanks Adam Leff
*   Fix attach router to also use port id if passed. thanks Andrew Battye
*   When getting a v3 identity service from the catalog, make sure the path includes /v3. thanks Darren Hague
*   Fix issue #3662 - copy openstack_identity_endpoint option to @openstack_identity_public_endpoint. thanks Darren Hague
*   Extract dynect bin from fog to fog-dynect. thanks Glenn Pratt
*   Fix deprecated call to security_groups. thanks Greg Blomquist
*   Fix deprecated call to resources. thanks Greg Blomquist
*   Cloud Director supports multiple peer subnets. thanks Josh Myers
*   Openstack missing passing of unscoped_token. thanks Ladislav Smola
*   Allow Rackspace-specific options for get_object_https_url. thanks Oleg Vivtash
*   Code prettified. thanks Oleg Vivtash
*   Ruby187 hash syntax. thanks Oleg Vivtash
*   Fog::Storage[:rackspace] object requests test update. thanks Oleg Vivtash
*   Fog::Storage[:rackspace] object requests test cleanup. thanks Oleg Vivtash
*   relax dependency for fog-ecloud. thanks Praveen Arimbrathodiyil
*   support allowed address pairs. thanks pyama86
*   style. thanks pyama86
*   api path set. thanks pyama86

#### [openstack]
*   allow auth_token attribute to be written to. thanks Darren Hague
*   align recognized parameters, move common things among services into openstack core. thanks Maurice Schreiber
*   undo premature move of identity_service_type: default value does no good. thanks Maurice Schreiber
*   orchestration: add missing collection requires, path variable already contains tenant_id. thanks Maurice Schreiber
*   core: fix wrong merge in 3b129ab9b2eac1cddc3fa680c88f436a6a853474. thanks Maurice Schreiber


## 1.33.0 08/12/2015
*Hash* 514fb792da07e6c5beaf4b735ea944fa873483f0

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 11035171
Forks         | 1472
Open Issues   | 78
Watchers      | 3573

**MVP!** Darren Hague

#### [Dynect]
*   Extract Dynect DNS provider to fog-dynect. thanks Glenn Pratt

#### [misc]
*   vCloud Director queued tasks should not count as "non_running". thanks Adam Leff
*   Add execute request. thanks Alan Sebastian
*   Fix comment: 5mins = 300s. thanks Andrew Langhorn
*   Allow real OpenStack storage adapter to take :openstack_management_url option. thanks Danny Guinther
*   [openstack][Storage] Added the delete_at and delete_after flags. thanks Francesco Vollero
*   Vsphere - customizing interfaces and disks when cloning from template. thanks as
*   Add support for multiple VPN tunnels. thanks Josh Myers
*   Adding Openstack Collection base class. thanks Ladislav Smola
*   Openstack Model base class. thanks Ladislav Smola
*   Fog::OpenStack::Model base class for all openstack models. thanks Ladislav Smola
*   Fog::OpenStack::Collection base class for all openstack collections. thanks Ladislav Smola
*   OpenStack compute add full support of availability zones. thanks Ladislav Smola
*   OpenStack servers list options fix. thanks Ladislav Smola
*   Adding OpenStack volume availability_zones. thanks Ladislav Smola
*   OpenStack compute add shelve related actions. thanks Ladislav Smola
*   Add missing require of identitty v3. thanks Ladislav Smola
*   update Linode avail_datacenters mock results. thanks Marques Johansson
*   add extend_volume request to Fog::Volume::OpenStack. thanks Stefan Majewsky
*   fucking 1.8.7. thanks Stefan Majewsky
*   fix test run on JRuby. thanks Stefan Majewsky
*   Use traverse to get resource pools, fixes #3579. thanks alan
*   Fix nested folders in get virtual machine. thanks alan
*   Intermediate foldes in DC/Cluster tree. thanks slivik

#### [openstack]
*   Allow the auth_token to be overridden (e.g. with the admin token from keystone.conf). thanks Darren Hague
*   Deal with Compute 'server details' returning null user_data. thanks Darren Hague
*   Add support for hierarchical projects. thanks Darren Hague
*   Add test for subnet creation. thanks Darren Hague
*   Add tests for subtree_as_list and parents_as_list in hierarchical projects. thanks Darren Hague
*   hierarchical projects: subtree_as_list and parents_as_list - set subtree and parents attributes as Array of Project instead of Array of Hash. thanks Darren Hague
*   hierarchical projects: Add test to check that a newly added subproject appears in a top-level project's list. thanks Darren Hague
*   Refactoring to avoid having to copy/paste openstack options to/from instance variables. thanks Darren Hague
*   fix subnet update & create regarding to empty vanilla options, add allocation_pools option. thanks Maurice Schreiber
*   mock create subnet array options. thanks Maurice Schreiber
*   fix broken subnet test. thanks Maurice Schreiber
*   reduce code duplication between specs. thanks Stefan Majewsky
*   fix test run so that the volume_spec.rb is actually run. thanks Stefan Majewsky
*   reduce code duplication in volume spec... thanks Stefan Majewsky
*   add volume transfer models/requests. thanks Stefan Majewsky


## 1.32.0 07/02/2015
*Hash* 3339ba764f099c1fab8c989510c427ac65dabeca

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 10420612
Forks         | 1453
Open Issues   | 83
Watchers      | 3538

**MVP!** Ladislav Smola

#### [cloudstack]
*   Use `isdefault` in `listNetworks` response. thanks Yamashita Yuu

#### [misc]
*   Various fixes & tweaks for OpenStack Identity V3 API & related tests. thanks Darren Hague
*   Clamp fog-ecloud at 0.1.1 because 0.1.2 was causing a Travis build failure. thanks Darren Hague
*   Reintroduce user_domain and project_domain     Refactor - move repetitive code from compute & network to core.     Tweak VCR config and Rakefile to make sure tests are run correctly. thanks Darren Hague
*   Fix ruby 1.8.7 failure. thanks Darren Hague
*   Add missing reference to openstack_project_name & simplify test code a little. thanks Darren Hague
*   Adding OpenStack Host Aggregate support. thanks Ladislav Smola
*   OpenStack Baremetal list methods unified interface. thanks Ladislav Smola
*   We need to move all list methods to unified interface, where     only Hash is passed as a first argument. The hash can have     specific fields, that will be recognized and deleted. Rest     of the Hash goes directly to request :query. thanks Ladislav Smola
*   OpenStack Keystone and Ironic change all to detailed list. thanks Ladislav Smola
*   OpenStack Cinder, Swift and Tuskar list methods unified interface. thanks Ladislav Smola
*   OpenStack Compute list methods unified interface. thanks Ladislav Smola
*   OpenStack Glance and Heat list methods unified interface. thanks Ladislav Smola
*   Minor bugs from list methods unification. thanks Ladislav Smola
*   Missing network init uri. thanks Ladislav Smola
*   OpenStack missing list unification of Network and Volume. thanks Ladislav Smola
*   Openstack security groups list typo. thanks Ladislav Smola
*   Don't remove nil keys in OpenStack#create_subnet. thanks Matt Darby
*   Send :force flag in Snapshot payload. thanks Matt Darby
*   OpenStack create_volume: add metadata option. thanks Maurice Schreiber
*   OpenStack volume model: add metadata attribute. thanks Maurice Schreiber
*   OpenStack port: add security groups to model and update request. thanks Maurice Schreiber
*   include core in identity_v3 mock. thanks Maurice Schreiber
*   correct mock format, when there is no input given. thanks Maurice Schreiber
*   Bump fog-aws dependency. thanks Quentin de Metz
*   add missing new method call to example. thanks Ryan King
*   first bits of a spec for Fog::OpenStack::Volume. thanks Stefan Majewsky
*   test the model create() method instead of the create_volume request. thanks Stefan Majewsky
*   Fix typo in vm_clone. thanks alan
*   bump fog-core dep. thanks geemus
*   comment attribute in ovirt. thanks karmab
*   support security-group by create port. thanks kazuhiko yamashita

#### [openstack]
*   Minor bugfixes & cleanups in identity_v3 test code. thanks Darren Hague


## 1.31.0 06/05/2015
*Hash* 8c653412b40dd82f82187b9710ccb9177dab3d98

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 10004131
Forks         | 1444
Open Issues   | 77
Watchers      | 3515

**MVP!** TerryHowe

#### [cloudstack]
*   Allow specifying the size of DATADISK on the creation of a server. thanks Yamashita Yuu

#### [misc]
*   Fixes #3084: Implement OpenStack Identity V3 API. thanks Darren Hague
*   Support the full vmware customization spec. thanks Francois Herbert
*   remove comma from end of hash to fix error with ruby 1.8.7 test. thanks Francois Herbert
*   Openstack Ironic maintenance mode. thanks Ladislav Smola
*   OpenStack add nova service support. thanks Ladislav Smola
*   Fog::OpenStack::Compute: remove assumption about endpoint URL format. thanks Stefan Majewsky
*   OpenStack rename flavor extra specs to metadata. thanks TerryHowe
*   OpenStack allow domains to be optional fix warning. thanks TerryHowe
*   Do not double encode image query. thanks TerryHowe
*   Fix OpenStack compute docs. thanks TerryHowe
*   Adding list_zones call to OpenStack. thanks Tom Caspy
*   added tests for flavor extra_specs. thanks Mainn Chen
*   rework tasks to better integrate github release creation/tagging. thanks geemus
*   Upgraded fog-core to version 1.30. thanks gust

#### [openstack|baremetal]
*   added support for setting node power/provision states. thanks Mainn Chen

#### [openstack|compute]
*   added support for flavor extra_specs. thanks Mainn Chen


## 1.30.0 05/07/2015
*Hash* 7de752a9554c0437a7112ec47829f52988ef1444

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 9587472
Forks         | 1436
Open Issues   | 85
Watchers      | 3479

**MVP!** Josef Stribny

#### [Brightbox]
*   Remove provider specific helper test. thanks Paul Thornthwaite

#### [GleSYS]
*   server/create: sync required and optional args with API spec. thanks Tobias Nygren

#### [Rackspace|Documentation]
*   Documenting the Networks option. thanks James Belchamber

#### [cloudstack|compute]
*   Public IP Address model improvement. thanks Atsushi Sasaki

#### [dynect|dns]
*   include SOA and NS records in #records response. thanks Richard Henning

#### [misc]
*   Add missing attributes to stack and resource. thanks Bill Wei
*   Supporting openstack auth v3 - project/user domain for compute/network. thanks Christophe Larsonneur
*   Introduce disk-snapshot and VM shutdown functionality. thanks Evgeny Yurchenko
*   image_pool request introduced. thanks Evgeny Yurchenko
*   Fixes #3543, adds support for cpuHotAdd and memoryHotAdd. thanks Francois Herbert
*   update CONTRIBUTING to point to design document in wiki. thanks Isaac Hollander McCreery
*   Hash#reject! returns nil if no changes were made; it is not correct behavior in assignment. thanks Jaroslav Barton
*   Fix the 'redirect to master' functionality. When authenticating towards a slave host, the error HOST_IS_SLAVE is returned by the slave host together with the IP address of the master host. Previously this resulted in an InvalidLogin exception which was hiding the actual cause. Now it results in an HostIsSlave exception which is then used to redirect the connection to the master host in case :xenserver_redirect_to_master is true. thanks Jonas Kongslund
*   Remove libvirt provider specific files. thanks Josef Stribny
*   Add modular dependency on extracted fog-libvirt. thanks Josef Stribny
*   Remove libvirt bin file. thanks Josef Stribny
*   Travis: Install libvirt header files to compile ruby-libvirt. thanks Josef Stribny
*   Remove dependency on fog-libvirt altogether. thanks Josef Stribny
*   Remove libvirt tests from fog. thanks Josef Stribny
*   Added vsphere_debug flag for stderr debugging. thanks Lukas Zapletal
*   add Linode Singapore DC to mock data. thanks Marques Johansson
*   Set proper content type and clear operations after request. thanks Matt Darby
*   Fixing Unrecognized argument: path warning message. thanks Miguel Martinez
*   name and storage profile VM configuraiton during vApp instantiation. thanks Miguel Martinez
*   vcloud-token on instantiation. thanks Miguel Martinez
*   Remove Google code. thanks Paulo Henrique Lopes Ribeiro
*   Remove Google tests. thanks Paulo Henrique Lopes Ribeiro
*   Remove Google main file. thanks Paulo Henrique Lopes Ribeiro
*   Remove Google Binary. thanks Paulo Henrique Lopes Ribeiro
*   Remove mocks for Google. thanks Paulo Henrique Lopes Ribeiro
*   Depend on fog-google. thanks Paulo Henrique Lopes Ribeiro
*   Force version 0.0.2 of fog-google. thanks Paulo Henrique Lopes Ribeiro
*   add firmware support for vsphere. thanks Samuel Keeley
*   Allow passing query options to snapshots endpoint. thanks Sean Handley
*   Change openstack_prj to openstack_project. thanks TerryHowe
*   Host and port options support for create_temp_url. thanks biomancer
*   Fix hp storage tests. thanks biomancer
*   Use sane default ports for get_object_http(s)_url. thanks biomancer
*   Compatibility fix for ruby 1.8.7 that does not have URI.encode_www_form method. thanks biomancer
*   Make port option overridable for get_object_http(s)_url. thanks biomancer
*   Fixing indentation. thanks eyurchenko
*   Tests added for vm_disk_snapshot, vm_shutdown and image_pool requests. thanks eyurchenko
*   Remove empty Mock classes. thanks eyurchenko
*   Return to "standard" template name. thanks eyurchenko
*   Remove puts (leftovers from debugging tests). thanks eyurchenko

#### [opennebula]
*   added get_by_name for network model. thanks ller
*   identify the network by id or name within a flavor. thanks ller
*   fixed networks.get_by_name. thanks ller
*   changed list_networks mock names. thanks ller
*   added mock for template_pool. thanks ller
*   added flavor tests. thanks ller
*   flavor: fixed get_vcpu and get_memory; added tests. thanks ller
*   removed dead debug code. thanks ller
*   added better string escaping for schedule requirements and raw sections. thanks ller
*   fix: escape RAW parameter the right way. thanks ller
*   fixed networks.get_by_name, added tests. thanks ller

#### [vsphere|compute]
*   Find virtual machines and templates under a folder. thanks Kevin Menard
*   Fixed spacing. thanks Kevin Menard


## 1.29.0 04/02/2015
*Hash* 90e96f36e6f70a12f0c6794a149231c337293887

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 9116129
Forks         | 1417
Open Issues   | 83
Watchers      | 3433

**MVP!** Chris Luo

#### [GleSYS]
*   Add ability to persist changes on existing server. thanks Christoffer Artmann
*   add support for SSH key management. thanks Tobias Nygren

#### [glesys]
*   fix URL encoding of API parameter values. thanks Tobias Nygren

#### [google]
*   Add credentials tests. thanks Ferran Rodenas

#### [google|compute]
*   Adding start_server and stop_server. thanks Daniel Broudy

#### [misc]
*   Initial integration of powerdns. thanks Chris Luo
*   Fix binspec def. thanks Chris Luo
*   Debug modularization and integration. thanks Chris Luo
*   Initial integration of powerdns. thanks Chris Luo
*   Fix binspec def. thanks Chris Luo
*   Debug modularization and integration. thanks Chris Luo
*   gemspec powerdns update. thanks Chris Luo
*   fix powerdns_spec.rb. thanks Chris Luo
*   revert modular providers messup. thanks Chris Luo
*   missing powerdns require in bin. thanks Chris Luo
*   fix formatting in gemspec. thanks Chris Luo
*   Remove server.cost.amount from Formats:Details as it breaks the tests when server has a cost that is a non decimail number. thanks Christoffer Artmann
*   Use OpenVZ and Debian 7.0 64-bit as default options when creating a server as GleSYS has deprecated their Xen platform. thanks Christoffer Artmann
*   Changed tests to use Vmware and Debian 7 instead of Xen and Debian 6. thanks Christoffer Artmann
*   Update test to expect CPU Usage as a Nullable Float. thanks Christoffer Artmann
*   zone.id instead of zone.domain. thanks Hippie Hacker
*   Move contributing guidelines from fog.io to CONTRIBUTING.md; closes #3509. thanks Isaac Hollander McCreery
*   CONTRIBUTING: discuss ongoing changes, link to Roadmap in Wiki and relevant issues. thanks Isaac Hollander McCreery
*   allow self-signed certs. thanks Jared Everett
*   Adds `ovirt_filtered_api` to list of recognized options for Ovirt service. thanks Jesse Hallett
*   Treat __sr as a string representing an opaque reference to a storage repository. See https://github.com/fog/fog/pull/3469. thanks Jonas Kongslund
*   Allow setting gateway option in CustomizationIPSettings. thanks Justin Pratt
*   Remove superfluous if modifier. thanks Justin Pratt
*   added requests files for linode image and linode disk api calls. thanks Marques Johansson
*   use Fog::Mock.random_numbers where appropriate. thanks Marques Johansson
*   fix mock for linode_disk_createfromimage. thanks Marques Johansson
*   added tests for the new linode requests. thanks Marques Johansson
*   use correct api_action in linode_disk_update. thanks Marques Johansson
*   use correct identifier for linode_disk_createfromimage. thanks Marques Johansson
*   revise linode expected results. thanks Marques Johansson
*   add linode.disk.createfromimage(..label..) param. thanks Marques Johansson
*   add missing ImageID, DiskID from linode.disk.imagize, linode.disk.resize responses. thanks Marques Johansson
*   Use fog-core 1.27.4 and above. thanks Matt Bostock
*   Rackspace Neutron Security Groups & Rules. thanks Matt Darby
*   Better help address for Rackspace. thanks Matt Darby
*   Added support to requests V3 tokens and provision compute using V3 keystone auth. thanks Miguel Z
*   Added extra parameters for domain suffixes and gateway, added comments. thanks Oscar Elfving
*   vm_clone used regular virtual switches no matter what kind of portgroup was named, changed it to look up and handle distributed virtual switches correctly. thanks Oscar Elfving
*   Fixed Ruby 1.8 breaking comma. thanks Oscar Elfving
*   Makes the docker api version call use assigned connection. thanks Partha Aji
*   Test `Provider[]` errors when unknown. thanks Paul Thornthwaite
*   Tests top level classes interface. thanks Paul Thornthwaite
*   Do not skip tests when configuration is missing. thanks Paul Thornthwaite
*   Remove test references to xenserver. thanks Paul Thornthwaite
*   Apply style rules to fog.gemspec. thanks Paul Thornthwaite
*   DRY up specs with `spec_helper`. thanks Paul Thornthwaite
*   Add Simplecov for coverage. thanks Paul Thornthwaite
*   Fix Xenserver VDI creation. thanks Paulo Henrique Lopes Ribeiro
*   Remove Atmos Bin. thanks Paulo Henrique Lopes Ribeiro
*   Add alias attribute to ovirt/compute/volume.rb. thanks Pavol Dilung
*   Implement affinity groups. thanks Pavol Dilung
*   Remove dangeling references to pry debugger. thanks Pavol Dilung
*   Implement affinity group mockups. thanks Pavol Dilung
*   Fine-tune affinity group mockups. thanks Pavol Dilung
*   Implement wipe_after_delete attribute for Fog::Compute::Ovirt::Volume class. thanks Pavol Dilung
*   Adds Planning service to OpenStack provider. thanks Petr Blaho
*   Adds Role model and list_roles request. thanks Petr Blaho
*   Adds Plan model, list_plans and get_plan requests. thanks Petr Blaho
*   Adds template retrieving into Plan. thanks Petr Blaho
*   Adds create_plan and delete_plan requests. thanks Petr Blaho
*   Adds adding and removing Roles from Plan. thanks Petr Blaho
*   Adds patch_plan request and patch method to Plan. thanks Petr Blaho
*   Adds RESTlike methods to Plan of Planning service. thanks Petr Blaho
*   Adds brief docs for OpenStack Planning service. thanks Petr Blaho
*   Adds few examples for OpenStack Planning service. thanks Petr Blaho
*   Add endpoint for hypervisor stats. thanks Sean Handley
*   Fix path and include request in catalog. thanks Sean Handley
*   fixes inconsistent spacing. thanks Tony Ta
*   removes unnecessary commas. thanks Tony Ta
*   more consistent spacing around blocks. thanks Tony Ta
*   fix inconsistent hash spacing. thanks Tony Ta
*   Extract local storage provider. thanks Ville Lautanala
*   Revert "allow self-signed certs for Joyent". thanks Wesley Beary
*   fix minor typo in get_object_https_url. thanks stephen charles baldwin

#### [openstack|identity]
*   check_token and validate_token - make tenant_id optional. thanks Darren Hague
*   add tests for check_token and validate_token parameters. thanks Darren Hague

#### [ovirt]
*   Fix update_interface method. thanks Pavol Dilung
*   Implement high availability flag an priority attributes. thanks Pavol Dilung


## 1.28.0 02/19/2015
*Hash* d023ee520bcf52072f50f03e22efde344caef936

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 8526269
Forks         | 1402
Open Issues   | 86
Watchers      | 3382

**MVP!** Peter Souter

#### [HP|storage]
*   Add support for headers to get_object. thanks Bruz Marzolf

#### [Openstack|Servers|Create]
*   Allow :volume_size in block_device_mapping_v2. thanks Brandon Dunne

#### [google]
*   Add support for JSON key format. thanks Ferran Rodenas

#### [joyent|compute]
*   support for gracefully handling 400 error responses from api Fixes #3434. thanks Kevin Chan

#### [misc]
*   Port Rackspace Orchestration implementation to OpenStack. thanks Bill Wei
*   Pass options when get resources from a stack. thanks Bill Wei
*   Add ubuntu-os-cloud to list of global projects. thanks Chris Gianelloni
*   get resource pool without name. thanks Chris Thompson
*   Add nic_type option. thanks Darren Foo
*   Adding multiple server support for Docker. thanks David Davis
*   Fixes "Error - undefined method 'delete' for nil:NilClass" when attempting to stop a container. thanks Dmitri Dolguikh
*   Remove duplicate openstack_region key. thanks Kyle Tolle
*   Add OpenStack Ironic support. thanks Ladislav Smola
*   Ming Jin: added list/get compute_resource functions. thanks Ming Jin
*   Ming Jin: expose effective attribute. thanks Ming Jin
*   Ming Jin: add isSingleHost attribute to compute resource. thanks Ming Jin
*   Ming Jin: fix nil usage issue of host. thanks Ming Jin
*   Ming Jin: added appropriate mocked response. thanks Ming Jin
*   Fix RDoc build. thanks Paulo Henrique Lopes Ribeiro
*   Fix small typo. thanks Paulo Henrique Lopes Ribeiro
*   Remove RiakCS. thanks Paulo Henrique Lopes Ribeiro
*   Remove tests. thanks Paulo Henrique Lopes Ribeiro
*   Remove unused credentials. thanks Paulo Henrique Lopes Ribeiro
*   Remove Bin. thanks Paulo Henrique Lopes Ribeiro
*   Add Fog::RiakCS as dependency. thanks Paulo Henrique Lopes Ribeiro
*   Add floating disks manipulation in rbovirt provider. thanks Pavol Dilung
*   Fix method names errors in exception. thanks Pavol Dilung
*   Add missing braces. thanks Pavol Dilung
*   Updates location to get API keys from. thanks Peter Souter
*   Adds section about SSH key management. thanks Peter Souter
*   Adds notes about how to bootstrap a server. thanks Peter Souter
*   Fix typo. thanks Peter Souter
*   Adds RDoc for #bootstrap, #get(id) and #all(). thanks Peter Souter
*   Removes not about not being documented. thanks Peter Souter
*   adding option to set ovirt to use filtered API. thanks Tom Caspy
*   adding version attribute for ovirt template. thanks Tom Caspy
*   Remove duplicate lines from code example. thanks Tomas Varaneckas
*   Use correct variable in code example. thanks Tomas Varaneckas
*   remove redundant requires. thanks geemus
*   cloudinit to customspec support. thanks karmab
*   Use Fog::Formatador. thanks starbelly

#### [vsphere]
*   new default dest_folder in vm_clone. thanks Chris Thompson
*   find network by name and dvswitch. thanks Chris Thompson
*   Supplied a mock implementation for cloudinit_to_customspec. thanks Kevin Menard
*   searching for VM improved to search whole cluster instead of current folder. thanks Matthew Black


## 1.27.0 01/12/2015
*Hash* 8a8f9a366be09de646536f06e2bcc84eb9229087

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 8014597
Forks         | 1382
Open Issues   | 133
Watchers      | 3336

**MVP!** Paulo Henrique Lopes Ribeiro

#### [AWS]
*   Tests covering "bin" interface. thanks Paul Thornthwaite
*   Extract service mapping. thanks Paul Thornthwaite
*   Fix test and data pipeline issue. thanks Paul Thornthwaite
*   Tests covering "bin" interface. thanks Paul Thornthwaite
*   Extract service mapping. thanks Paul Thornthwaite
*   Fix test and data pipeline issue. thanks Paul Thornthwaite

#### [GH-3378]
*   Reinstate JRuby CI runs. thanks Paul Thornthwaite

#### [Openstack]
*   Update example for Servers.create with :block_device_mapping_v2. thanks Brandon Dunne

#### [aws]
*   mocks and models for SNS. thanks Eugene Howe

#### [aws/sns]
*   basic subscription mock. thanks Josh Lane

#### [aws|put_object]
*   guard against non-us_ascii x-amz-meta-* values. thanks Jan Raasch
*   do not check user meta data encoding for ruby-1.8.7. thanks Jan Raasch

#### [misc]
*   add storage_type to rds server. thanks Adam Reese
*   add models for firewall, egress_firewall, networks, port_forwarding, projects, public_ip_addresses.  Also fix 3015 (support project_id in key calls). thanks Athir Nuaimi
*   add network offerings model and add functionality to egress_firewall_rule model. thanks Athir Nuaimi
*   add initial extra testing for cloudstack enhancements. thanks Athir Nuaimi
*   add a number of tests for cloudstack requests. thanks Athir Nuaimi
*   add models for firewall, egress_firewall, networks, port_forwarding, projects, public_ip_addresses.  Also fix 3015 (support project_id in key calls). thanks Athir Nuaimi
*   add network offerings model and add functionality to egress_firewall_rule model. thanks Athir Nuaimi
*   add initial extra testing for cloudstack enhancements. thanks Athir Nuaimi
*   fix failing test for cloudstack flavors. thanks Athir Nuaimi
*   fix failed travis test with cloudstack on ruby 1.8.7. thanks Athir Nuaimi
*   issue #3275, setting path_style to true for signature_version 4. thanks Christian Ott
*   path_style debugging. thanks Christian Ott
*   check path_style for nil. thanks Christian Ott
*   remove debug msg. thanks Christian Ott
*   issue #3275, set path_style for get_bucket_location only, remove larger scope. thanks Christian Ott
*   Add configuration for path_style to RiakCS Provisioning client. Defaults the false if no user input is given (following the style for the s3client default settings). thanks Derek Richard and Karen Wang
*   rds event subscriptions. thanks Eugene Howe
*   All I want for Christmas are logs clean of warnings about HTTPS access to my     bucket... thanks Frederic Jean
*   Revert "Revert "Run Fog tests for Ruby 2.2.0"". thanks Frederick Cheung
*   Add ovirt_ca_no_verify option for ovirt provider. thanks Ilja Bobkevic
*   get_topic_attributes handle nil values. thanks Josh Lane
*   fog-aws module. thanks Josh Lane
*   fix aws bin. thanks Josh Lane
*   Rackspace Neutron (Networking) Support. thanks Matt Darby
*   Rackspace's new CDN (V2). thanks Matt Darby
*   Launch. thanks Matt Darby
*   Fix [excon][WARNING] Invalid Excon request keys: :host exception. thanks Mevan Samaratunga
*   Test service abstraction code loading. thanks Paul Thornthwaite
*   This limits 1.8.7 to use `activesupport-v3.2.21`. thanks Paul Thornthwaite
*   Ignore JRuby failures until investigated. thanks Paul Thornthwaite
*   First batch of deprecation of requests in Xenserver. thanks Paulo Henrique Lopes Ribeiro
*   Fix build in ruby 1.8.7. thanks Paulo Henrique Lopes Ribeiro
*   Remove command gem update from travis build. thanks Paulo Henrique Lopes Ribeiro
*   Added more deprecations. thanks Paulo Henrique Lopes Ribeiro
*   Added deprecation notice to destroy requests. thanks Paulo Henrique Lopes Ribeiro
*   Deprecated all requests. thanks Paulo Henrique Lopes Ribeiro
*   Deprecating methods in models. thanks Paulo Henrique Lopes Ribeiro
*   Fix indentation. thanks Paulo Henrique Lopes Ribeiro
*   Removed Serverlove code. thanks Paulo Henrique Lopes Ribeiro
*   Removed Serverlove tests. thanks Paulo Henrique Lopes Ribeiro
*   Removed Serverlove bin. thanks Paulo Henrique Lopes Ribeiro
*   Added modular Serverlove provider as dependency. thanks Paulo Henrique Lopes Ribeiro
*   Allowing users to fetch ec2 instances in batches. thanks Richard Hall
*   Grouping requestId, and nextToken together in DescribeInstances#end_element as they perform the same action. thanks Richard Hall
*   Improving docs for fetching EC2 instances in batches. thanks Richard Hall
*   Run Fog tests for Ruby 2.2.0. thanks Sean Handley
*   Revert "Run Fog tests for Ruby 2.2.0". thanks Sean Handley
*   [vSphere]: Add full path to cluster. thanks Shlomi Zadok
*   Add support for bucket notification configuration. thanks e Peignier
*   cleanup leftover files (now in fog-aws). thanks geemus
*   start_with_cloudinit function  (rbovirt). thanks karmab
*   Fix misbehavior around connection to slave node in pool. thanks ooVoo LLC
*   Fixed the issue according pool request #3356. thanks ooVoo LLC
*   Fix circular argument reference warnings for ruby 2.2. thanks starbelly
*   应俊 (1):. thanks starbelly
*   need region param. thanks starbelly

#### [openstack|storage]
*   fixes around file metadata. thanks geemus


## 1.26.0 12/12/2014
*Hash* 54dde02c11225c2fa63fa82e08bffcc0ad31a719

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 7729418
Forks         | 1364
Open Issues   | 148
Watchers      | 3299

**MVP!** Colin Hebert

#### [AWS|Storage]
*   make s3 IO based uploads retryable again. thanks Frederick Cheung
*   allow signature version to be set to 2 (WIP). thanks Frederick Cheung

#### [DigitalOcean]
*   Helper methods for flavor,image,region,ips. thanks Daniel Lobato

#### [Docker]
*   Environment variables support. thanks Daniel Lobato

#### [Openstack|Compute|Server]
*   Add test boot from block_device_mapping. thanks Brandon Dunne
*   Add test boot from block_device_mapping_v2. thanks Brandon Dunne
*   Rewrite block_device_mapping to support. thanks Brandon Dunne

#### [Openstack|Tests]
*   Add rake subtask for testing only Openstack. thanks Brandon Dunne

#### [aws|auto_scaling]
*   Add PlacementTenancy attribute for launch configuration. thanks Benjamin Pillet

#### [aws|dns]
*   Namespace xml to fix create_health_check. thanks James Findley

#### [aws|s3]
*   add changelog note about 7 day expiry. thanks geemus

#### [aws|storage]
*   redirect fixes to match latest and v4 sigs. thanks geemus
*   catch edge cases around redirect region/host. thanks geemus

#### [digitalocean]
*   reenable tests. thanks geemus

#### [digitalocean|compute]
*   add private_networking attribute. thanks geemus

#### [google|storage]
*   Reintroduce workaround for excon headers issue while keeping fix where file_data was not being saved. thanks Antonio

#### [misc]
*   Accept any 2xx status from head_containers. thanks Ash Wilson
*   Update describe_network_acls.rb. thanks Bryan Paxton
*   Add AssumeRoleWithSAML support for AWS. thanks Colin Hebert
*   Ensure that if the aws credentials requests requiring the signature fail. thanks Colin Hebert
*   Fix link to documentation. thanks Colin Hebert
*   Fix code style. thanks Colin Hebert
*   Add simple test. thanks Colin Hebert
*   Fix style. thanks Colin Hebert
*   fixed backups in DigitalOcean. thanks Denis Barishev
*   Do not throw a warning about falling back to path_style     ... if the user has already explicitly specified path_style (dots are, after all, a perfectly valid thing to have in a bucket name). thanks Eric Herot
*   Fix typo: Fog::Connection is deprecated, not Fog::XML::Connection. thanks Joe Rafaniello
*   recognize aws_signature_version option. thanks Jon K Hellan
*   Use old style date header for signature v2. thanks Jon K Hellan
*   Use the new build env on Travis. thanks Josh Kalderimis
*   Enhance images details call by query. thanks Ladislav Smola
*   Fix path with contained query. thanks Ladislav Smola
*   Moving Rackspace logic to fog-rackspace. thanks Matt Darby
*   Moved to Fog::Core. thanks Matt Darby
*   Revert "Moving Rackspace logic to fog-rackspace". thanks Matt Darby
*   Rackspace Orchestration Support. thanks Matt Darby
*   add block_device_mapping_v2. thanks Naoto TAKAHASHI
*   fixup! example block_device_mapping_v2. thanks Naoto TAKAHASHI
*   fixup!. thanks Naoto TAKAHASHI
*   Disable rackspace until fog-rackspace#10 is fixed. thanks Nat Welch
*   Rescue "Illegal Seek" exception in case body is a pipe or socket. thanks Paul Gideon Dann
*   Specs for existing `Fog::Bin` interface. thanks Paul Thornthwaite
*   Detailed checks for `Brightbox` class. thanks Paul Thornthwaite
*   Revert "Moved to Fog::Core". thanks Paul Thornthwaite
*   Mark broken DigitalOcean tests as pending. thanks Paul Thornthwaite
*   Mark additional DigitalOcean test as pending. thanks Paul Thornthwaite
*   Disable ALL DigitalOcean tests until fixed. thanks Paul Thornthwaite
*   Remove Rackspace references until reinstated. thanks Paul Thornthwaite
*   Reinstate Rackspace "bin" checks. thanks Paul Thornthwaite
*   More specs to cover `Fog` methods. thanks Paul Thornthwaite
*   Moved Ecloud to a modular gem. thanks Paulo Henrique Lopes Ribeiro
*   Moved StormOnDemand to its own gem. thanks Paulo Henrique Lopes Ribeiro
*   Removing Atmos. thanks Paulo Henrique Lopes Ribeiro
*   Adds openstack_region parameter to OpenStack Identity Service. thanks Renato Furter
*   Fix deprecation warning. thanks Sean Handley
*   Require fog/version for User-Agent header. thanks Terry Howe
*   ensure version is required. thanks geemus
*   add github release to changelog task. thanks geemus
*   bump fog-core dep. thanks geemus
*   Revert "bump fog-core dep". thanks geemus
*   bump fog-core dep. thanks geemus

#### [opennebula]
*   lazily require opennebula gem. thanks geemus

#### [storage|aws]
*   fix redirect follower + v4 sig regression. thanks geemus
*   further fixes around region redirecting. thanks geemus
*   make owner setter on file idempotent. thanks geemus
*   fix docs/code for put_bucket_logging. thanks geemus
*   more redirect tweaks. thanks geemus
*   tweak region redirecting. thanks geemus


## 1.25.0 11/18/2014
*Hash* 4728432a087f6d9661af0f18a660a27b68b3d947

Statistic     | Value
------------- | --------:
Collaborators | 2
Downloads     | 7406539
Forks         | 1336
Open Issues   | 181
Watchers      | 3271

**MVP!** Frederick Cheung

#### [AWS|Autoscaling]
*   Use Signature v4. thanks Frederick Cheung
*   Update list of regions accepted by the mocks. thanks Frederick Cheung

#### [AWS|CloudFormation]
*   Use Signature v4. thanks Frederick Cheung

#### [AWS|Cloudwatch]
*   Use Signature v4. thanks Frederick Cheung
*   Update list of regions allowed by the mock. thanks Frederick Cheung

#### [AWS|Compute]
*   switch to signature version 4. thanks Frederick Cheung

#### [AWS|Core]
*   add eu-central-1 to the region whitelist. thanks Frederick Cheung
*   Stop flapping test by clearing out mock data. thanks Frederick Cheung

#### [AWS|ELB]
*   Use Signature v4. thanks Frederick Cheung
*   Update list of regions the mocks allow. thanks Frederick Cheung

#### [AWS|Elasticache]
*   Use Signature v4. thanks Frederick Cheung

#### [AWS|Elasticbeanstalk]
*   Use Signature v4. thanks Frederick Cheung

#### [AWS|IAM]
*   Use signature version 4. thanks Frederick Cheung
*   Do not call Fog.mock! in tests. thanks Michael Hale
*   Also ignore Fog::AWS::IAM::NotFound (and return nil). thanks Michael Hale
*   Fix assigning path to IAM role. thanks Michael Hale
*   Fix user count tests (there will be at least 1 other user on the account for fog access). thanks Michael Hale

#### [AWS|RDS]
*   Use Signature v4. thanks Frederick Cheung
*   update list of regions accepted by mocks. thanks Frederick Cheung

#### [AWS|S3]
*   Vhost buckets don't work if bucket name has a . in it. thanks Frederick Cheung
*   switch to signature v4. thanks Frederick Cheung
*   use request_params to normalize/escape paths properly for delete/copy object. thanks Frederick Cheung
*   NOTE: v4 signatures mean that signed URLs can now only have up to 7 day expiry

#### [AWS|SNS]
*   Use Signature v4. thanks Frederick Cheung

#### [AWS|SQS]
*   Use Signature v4. thanks Frederick Cheung
*   Update list of regions allowed by mocks. thanks Frederick Cheung

#### [AWS|STS]
*   Use Signature v4. thanks Frederick Cheung

#### [AWS|Signature]
*   make signature v4 components easy to extract. thanks Frederick Cheung
*   V4 parameter signature needs to add X-Amz-Credential etc. before signing. thanks Frederick Cheung
*   fix handling of repeated slashes. thanks Frederick Cheung

#### [AWS|Signaturev4]
*   canonicalize . and .. in path. thanks Frederick Cheung

#### [AWS|Storage]
*   Need to check for nil headers. thanks Frederick Cheung
*   add a warning that we've fallen back to path style. thanks Frederick Cheung
*   post_object_restore should let request handle object_name to path conversion. thanks Frederick Cheung
*   update post_object_hidden_fields to use signature v4. thanks Frederick Cheung

#### [Brightbox]
*   Update Brightbox gem to add storage. thanks Paul Thornthwaite

#### [Docker]
*   Parse properly ports and links attributes. thanks Daniel Lobato

#### [Fog|Core]
*   Move fog/core/parser to fog-xml gem. thanks Frederick Cheung

#### [Openstack|Compute]
*   fix randomly failing spec. thanks Frederick Cheung

#### [aws]
*   - refactor validate_aws_region. thanks Shlomi Zadok

#### [aws|compute]
*   reload security group by id when available. thanks geemus

#### [cloudstack]
*   Add get volumes for server. thanks German Germanovich
*   Add get snapshots for volume. thanks German Germanovich
*   Add reset_password for server. thanks German Germanovich

#### [google|dns]
*   Add Project resource. thanks Ferran Rodenas
*   Add Zone model. thanks Ferran Rodenas
*   Add Record resource. thanks Ferran Rodenas
*   Add Change resource. thanks Ferran Rodenas
*   Add examples. thanks Ferran Rodenas
*   Add the ability to wait for a change completion RRSet operations. thanks Ferran Rodenas
*   Add get method to RRSet. thanks Ferran Rodenas

#### [google|storage]
*   Fix bug in files.get. thanks Nat Welch

#### [misc]
*   Added GovCloud region to acceptable AWS list. thanks Aaron Donovan
*   Updating authentication functions to prevent sending expired token. thanks Aaron Huber
*   Improved OpenNebula support. thanks Andrew Brown
*   Improved OpenNebula support. thanks Andrew Brown
*   Adding Tests and Mocks. thanks Andrew Brown
*   Fixing merge conflict. thanks Andrew Brown
*   Removing version dependency. thanks Andrew Brown
*   Remove extra space in HP Storage service type. thanks Bruz Marzolf
*   Fix Dynect job poll bug. thanks Chris Chalstrom
*   Add ubuntu-os-cloud to list of global projects. thanks Chris Gianelloni
*   add :type to RS LoadBalancers nodes. thanks Chris McClimans
*   make zones.get(domain_or_id) work, same as dnsimple. thanks Chris McClimans
*   Preserve @ symbols in vcloud_director usernames. thanks Dan Carley
*   Raise docker-api errors up. thanks Daniel Lobato
*   Docker: Support for logs/top operations. thanks Daniel Lobato
*   Handle Docker authentication errors. thanks Daniel Lobato
*   added support for searching of images in fogdocker. thanks Dmitri Dolguikh
*   Added ELB tags methods, mocks, and tests. thanks Eric Sakowski
*   Added tags attr to AWS security_groups and made sg.save() create tags. thanks Eric Sakowski
*   Adding fog-profitbricks as a runtime_dependency. thanks Ethan Devenport
*   [AWS|EMR| Use Signature v4. thanks Frederick Cheung
*   Pin to fog-xml 0.1.1. thanks Frederick Cheung
*   spelling mistake breaking the AWS SES service model. thanks Graeme Wilson
*   Add vsh_id attribute to Bluebox::Server. thanks Hiro Asari
*   Found a typo in the Changelog. thanks JJ Asghar
*   implements the public_url feature for openstack storage. thanks Julian Weber
*   Rackspace neutron (networking) support. thanks Matt Darby
*   Added docs/tests for Storage's public_url. thanks Matt Darby
*   Small whitespace tweak. thanks Nat Welch
*   Fixed attribute passing for add_interface. thanks Nick Huanca
*   Add support for AWS bucket website redirects. thanks Nils Landt
*   Rescue if IO throws exception on attempted #rewind. thanks Paul Gideon Dann
*   Requiring fog/version. thanks Paulo Henrique Lopes Ribeiro
*   Using `fog-xml`. thanks Paulo Henrique Lopes Ribeiro
*   Modularized Voxel Provider. thanks Paulo Henrique Lopes Ribeiro
*   Moved Vmfusion to its own gem. thanks Paulo Henrique Lopes Ribeiro
*   Move Terremark to its own gem. thanks Paulo Henrique Lopes Ribeiro
*   Add :job_poll_timeout to the list of recognized options. thanks Peter Drake
*   reload libvirt actions to get current state. thanks Shlomi Zadok
*   Clusters lists tests. thanks Shlomi Zadok
*   Fix spelling mistake in docs for AWS File#public_url. thanks Stephen Augenstein
*   Fix floating_ip detection for OpenStack Folsom Release. thanks Yury Tsarev
*   #3258 - allow modification of ConnectionSettings parameter of AWS ELB for IdleTimeout adjustments. thanks brettcave
*   Remove duplicated hash key in rackspace/mock_data.rb. thanks deepj
*   Bump the API version for DynamoDB put. thanks elkelk
*   explicitly load version info, now that core no longer implicitly does. thanks geemus
*   bump fog-core dep, cleanup user-agent expectation. thanks geemus
*   Revert "explicitly load version info, now that core no longer implicitly does". thanks geemus
*   nuke core/connection tests (duplicates tests now in fog-core). thanks geemus
*   clarify getting started README. thanks geemus

#### [openstack]
*   add remove header if setting directory back to private. Without it directory once public will stay like that forever. thanks Piotr Kedziora

#### [ovirt]
*   Added tests for update volume. thanks Bert Hajee
*   Add interface for updating volumes. thanks Erik van Pienbroek

#### [rackspace]
*   Queues: makes block optional when dequeuing. thanks  Lima

#### [vSphere]
*   Support clusters that are located below folders. thanks Shlomi Zadok
*   Support non-clusters setup. thanks Shlomi Zadok


## 1.24.0 10/09/2014
*Hash* 1bc78346c02294a0aa3e114f02e89143e0f25a4f

Statistic     | Value
------------- | --------:
Collaborators | 30
Downloads     | 6923953
Forks         | 1302
Open Issues   | 220
Watchers      | 3232

**MVP!** Michael Hale

#### [AWS]
*   Setup a fog keypair only if not supplied. thanks Timur Alperovich

#### [AWS|Beanstalk]
*   Add instrumentor. thanks Michael Hale

#### [AWS|CDN]
*   Add instrumentor. thanks Michael Hale

#### [AWS|CloudFormation]
*   Add instrumentor. thanks Michael Hale

#### [AWS|DNS]
*   Add  instrumentor. thanks Michael Hale

#### [AWS|DataPipeline]
*   Add instrumentor. thanks Michael Hale

#### [AWS|DynamoDB]
*   Add instrumentor. thanks Michael Hale

#### [AWS|EMR]
*   Add instrumentor. thanks Michael Hale

#### [AWS|Elasticache]
*   Add instrumentor. thanks Michael Hale

#### [AWS|Glacier]
*   Add instrumentor. thanks Michael Hale

#### [AWS|RDS]
*   Add instrumentor. thanks Michael Hale

#### [AWS|Redshift]
*   Add instrumentor. thanks Michael Hale

#### [AWS|SES]
*   Add instrumentor. thanks Michael Hale

#### [AWS|SNS]
*   Add instrumentor. thanks Michael Hale

#### [AWS|SQS]
*   Add instrumentor. thanks Michael Hale

#### [AWS|STS]
*   Add instrumentor. thanks Michael Hale

#### [AWS|SimpleDB]
*   Add instrumentor. thanks Michael Hale

#### [AWS|Storage]
*   Add instrumentor. thanks Michael Hale

#### [GH-3156]
*   Fix fog binary dependencies. thanks Paul Thornthwaite

#### [GH-3157]
*   Replace 1.9 hashes with Hash rockets. thanks Paul Thornthwaite
*   Fixed additional 1.9 hash. thanks Paul Thornthwaite

#### [aws|compute]
*   fix mock az filtering. thanks geemus

#### [aws|dns]
*   Fix some syntax errors. thanks Nat Welch
*   mark mocked tests as pending. thanks geemus
*   1.8 compat fix. thanks geemus

#### [aws|iam]
*   mock fixes. thanks geemus

#### [dynect|dns]
*   Let job_poll_timeout be specified. thanks Dan Peterson

#### [google|compute]
*   added centos, opensuse images. thanks Eric Johnson
*   Refactor Compute to use the new Shared module. thanks Ferran Rodenas
*   Change how get_region works for mocks. thanks Nat Welch
*   Make get_region look the same for real and mock. thanks Nat Welch
*   Change target pool code to be correct and consistent with fog. thanks Nat Welch
*   mark target pool tests as pending to fix travis. thanks geemus

#### [google|dns]
*   Add initial support for Google Cloud DNS. thanks Marcin Owsiany
*   Let non-mocked tests run by setting an env variable. thanks Marcin Owsiany
*   Add support for get_managed_zone, with tests. thanks Marcin Owsiany

#### [google|monitoring]
*   Add support for Google Cloud Monitoring. thanks Ferran Rodenas

#### [google|sql]
*   Initial support for Google Cloud SQL. thanks Ferran Rodenas
*   Add support for Flags. thanks Ferran Rodenas
*   Add support for Operations. thanks Ferran Rodenas
*   Add support for Instances. thanks Ferran Rodenas
*   Add support for SslCerts. thanks Ferran Rodenas
*   Add support for BackupRuns. thanks Ferran Rodenas
*   Add examples. thanks Ferran Rodenas
*   Use the correct directory for Google Cloud SQL examples. thanks Ferran Rodenas

#### [google|storage]
*   workaround excon headers issue. thanks geemus
*   fix for failing mocked object tests. thanks geemus

#### [hp|storage]
*   workaround excon headers issue. thanks geemus
*   fix storage tests to use new excon headers stuff. thanks geemus

#### [linode|compute]
*   Get number of CPU cores from the API. thanks Keefe

#### [misc]
*   openstack storage: add possibility to set publicity to containers. thanks  Lomoff
*   make public option of container attr_reader. thanks  Lomoff
*   fix mistyping in openstack storage directory model. thanks  Lomoff
*   Adding dnsSuffixList support. thanks Ahmed Elsabbahy
*   Reworded dnsSuffixList comment. thanks Ahmed Elsabbahy
*   warning: mismatched indentations at 'end' with 'def'. thanks Akira Matsuda
*   warning: assigned but unused variable - reponse. thanks Akira Matsuda
*   Remove region defaults from Rackspace services. thanks Ash Wilson
*   Remove the deprecation notices. thanks Ash Wilson
*   :lipstick: Whitespace. thanks Ash Wilson
*   Test different means of creating load balancers. thanks Ash Wilson
*   Yard docs and optional parameters for lbs. thanks Ash Wilson
*   Add deprecation notices to storage and queues. thanks Ash Wilson
*   Consistently use :rackspace_queues_url. thanks Ash Wilson
*   The "nodes" element is actually nullable. thanks Ash Wilson
*   Whitespace touchups. thanks Ash Wilson
*   Reorganize clb fixtures, add a minimal case. thanks Ash Wilson
*   Port and nodes are *not* required for LB creation. thanks Ash Wilson
*   Formatting stick!. thanks Ash Wilson
*   Test for creating a bootable volume. thanks Ash Wilson
*   Accept `:image_id` to create bootable volumes. thanks Ash Wilson
*   Wait for volumes to become available. thanks Ash Wilson
*   create_server request and test. thanks Ash Wilson
*   Allow manual specification of :block_device_mapping. thanks Ash Wilson
*   :block_device_mapping_v2 needs to be an Array. thanks Ash Wilson
*   Give the BFV servers different names. thanks Ash Wilson
*   Create bootable volumes from the Volume model. thanks Ash Wilson
*   Boot-from-volume doesn't work from standard flavors. thanks Ash Wilson
*   servers.create(:boot_volume_id or :boot_image_id). thanks Ash Wilson
*   Missed an accessor there. thanks Ash Wilson
*   Warn if you specify both boot_volume_id and boot_image_id. thanks Ash Wilson
*   Add an image id to mock volumes when appropriate. thanks Ash Wilson
*   All flavors are bootable if you're mocking. thanks Ash Wilson
*   add ebs optimization. thanks Ben Chadwick
*   remove leading slash from Rackspace compute_v2 request paths. thanks Ben Sandberg
*   catch invalid uri. thanks Chris Thompson
*   Require docker-api in Gemfile. thanks Daniel Lobato
*   added ready? for sshable. thanks Denis Barishev
*   Add support for granting and revoking DB access to Cloud Databases. thanks Evan Light
*   Handle host specification on database users. thanks Evan Light
*   create_user, grant_user_access, and revoke_user_access now support host access restrictions. thanks Evan Light
*   Oops. Added that initializer just so I could pry inside of it. Don't need it now!. thanks Evan Light
*   Oops another pry call to remove... thanks Evan Light
*   Check region against static list, only if host is a subdomain of amazonaws.com. thanks Fabian Wiesel
*   removing the depreciation warning when calling key_pair from an aws server. thanks Graeme Wilson
*   adding the get and put methods for the aws amazon password policy commands. thanks Graeme Wilson
*   rename put_account_password_policy to update_account_password_policy. thanks Graeme Wilson
*   cleaning up extra spaces. thanks Graeme Wilson
*   updating to the correct url for reference. thanks Graeme Wilson
*   adding the delete method for the aws account_password_policy. thanks Graeme Wilson
*   Show failure for Openstack Storate service_type. thanks Greg Blomquist
*   Update the Openstack Storage service type. thanks Greg Blomquist
*   Fix parsing of SpotInstanceRequests responce when we also specify NetworkInterface. thanks Igor Rodionov
*   Fix to follow ruby code style. thanks Igor Rodionov
*   Updating the HP connect docs. thanks JJ Asghar
*   Updated to CloudStack 4.3 and re-added historical function behavior. thanks Jeff Moody
*   Revert "Updated to CloudStack 4.4 API and re-added historical function behavior.". thanks Jeff Moody
*   Redux of update to CloudStack 4.4 API and supporting "overloaded" methods to support old and new styles of calling     CloudStack API functions.     This should allow all options to be passed as a single hash or as an ordered list of parameters. thanks Jeff Moody
*   Depend on fog-radosgw. thanks Jon K Hellan
*   Fix AWS::AutoScaling::Instance#healthy?. thanks Jordan Running
*   Allow get_object_https_url to accept a method. thanks Kieran Pilkington
*   Adjust get_object_https_url method documentation. thanks Kieran Pilkington
*   Local storage: Always try to create directories, handle already existing. thanks Mark Yen
*   remove hack for linode not filtering avail.linodeplans by planid. thanks Marques Johansson
*   rescue with correct Linode::NotFound namespace. thanks Marques Johansson
*   Error if FOG_CREDENTIAL doesn't match session. thanks Matt Bostock
*   Add vertical spacing for readability. thanks Matt Bostock
*   Clean up Excon::Errors::SocketError::EOFError warning in vcloud_directory. thanks Matt Ray
*   Correct typos. thanks Riordan
*   Support for core Route53 HealthChecks API calls. thanks Riordan
*   Add missing fields from DNS server requests. thanks Riordan
*   Add missing fields to DNS record model. thanks Riordan
*   change service catalog lookup to be type based. thanks Mike Hagedorn
*   change to OS type request on failure. thanks Mike Hagedorn
*   make default lookup key in ServiceCatalog type and not name. thanks Mike Hagedorn
*   dont run a real test if the mocks are enabled. thanks Mike Hagedorn
*   vaguely working Query mixin. thanks Mike Pountney
*   Solid query API mixin, with tests. thanks Mike Pountney
*   Mock vdc model tests are passing. thanks Mike Pountney
*   find_by_query support for vdcs collection. thanks Mike Pountney
*   Fix failing test -- Description is optional. thanks Mike Pountney
*   Add Query support to Vms. thanks Mike Pountney
*   Enable model vapp_tests in Mock mode. thanks Mike Pountney
*   Enable Mock support for Model task tests. thanks Mike Pountney
*   Add query support to tasks model, inc Mock. thanks Mike Pountney
*   Fix up tasks_tests; add missing data from Mock. thanks Mike Pountney
*   no mock for custom_fields. thanks Mike Pountney
*   vApp get_execute_query 'get by name' mock. thanks Mike Pountney
*   Fix error in assumption about TaskRecord queries. thanks Mike Pountney
*   Replace Fog::Time with Time. thanks Mike Pountney
*   Make task record translation more robust. thanks Mike Pountney
*   TaskRecord ObjectName is optional. thanks Mike Pountney
*   Empty commit to prompt Travis run. thanks Mike Pountney
*   Not specifying Owner details caused issue in Query Mock. thanks Mike Pountney
*   Whitespace cleanup of #3069. thanks Nat Welch
*   add missing HEAD Bucket request, with a basic test in there. thanks Nathan Sullivan
*   adding support for network interfaces and public IP association (non-default VPCs) for EC2 spot instances. thanks Nathan Sullivan
*   Revert "adding support for network interfaces and public IP association (non-default VPCs) for EC2 spot instances". thanks Nathan Sullivan
*   added public? and acl method to s3 file and minor refactoring. thanks Nico
*   adding tests for aws file acl and public? method. thanks Nico
*   Move chunk_size parameter to the connection_options table. thanks Pierre Massat
*   Vcloud director: Add static routing support to Edge Gateway. thanks Simas Cepaitis
*   Improve test a bit. thanks Simas Cepaitis
*   Fix typo. thanks Simas Cepaitis
*   :GatewayInterface is located 1 level deeper. thanks Simas Cepaitis
*   allow userdata to be passed to Rackspace AutoScale. thanks Thom May
*   Accept Block For Get Requests. thanks Tim
*   resolve conflicts. thanks Tim
*   remove Git Markup. thanks Tim
*   Revert "S3 invalid signature generation". thanks Wesley Beary
*   Make possible to get credentials value, since it's needed to start a console connection. thanks com
*   fixes around MVP. thanks geemus
*   update contributors. thanks geemus
*   remove files duplicated from fog-core. thanks geemus
*   fix signature to properly escape. thanks lawrence
*   Update signaturev4.rb. thanks lawrence
*   remove sakuracloud libs and add fog sakura-cloud to gem depends. thanks sawanoboly
*   remove fog/bin/sakuracloud and copy it to fog_sakuracloud. thanks sawanoboly
*   Added backend services resource to gce compute. thanks snyquist2
*   Added backend services example and model classes. thanks snyquist2
*   added 'add backend services backend', global forwarding rules, target http proxies, and url maps. thanks snyquist2
*   fixed bug in global forwarding rules get. thanks snyquist2
*   fixed whitespace issues. thanks snyquist2
*   fixed whitespace issues. thanks snyquist2
*   correct files changes accidentally. thanks snyquist2
*   correct issues in previous commit. thanks snyquist2
*   fixed previous commit. thanks snyquist2
*   remove excess file. thanks snyquist2
*   added tests for list requests. thanks snyquist2
*   corrected naming on tests. thanks snyquist2
*   fixed image create. thanks snyquist2
*   added tests for http health checks, images, target pools, and forwarding rules. thanks snyquist2
*   modified l7 load balancing example. thanks snyquist2

#### [oVirt]
*   expose ips attribute. thanks Erik van Pienbroek

#### [openstack]
*   should allow endpoint_type on storage for authentication. thanks Guilherme Souza
*   fix network.rb. thanks Naoto TAKAHASHI

#### [rackspace]
*   Add support for httpsRedirect flag. thanks Mike Dillon
*   Fetch https_redirect on demand if it is nil. thanks Mike Dillon
*   set default region in mock helper for tests. thanks geemus


## 1.23.0 07/17/2014
*Hash* 19c712a0b0d449c0e0cceaf94e3ee8703814db32

Statistic     | Value
------------- | --------:
Collaborators | 30
Downloads     | 6050760
Forks         | 1243
Open Issues   | 192
Watchers      | 3129

**MVP!** Achim Ledermüller

#### [#3048]
*   Lock down rest-client version. thanks Paul Thornthwaite
*   Don't drop 1.8.7 checking yet. thanks Paul Thornthwaite

#### [AWS]
*   add describe_vpc_attribute. thanks Konstantinos Natsakis

#### [AWS|Compute]
*   support for modify_subnet_attribute. thanks Frederick Cheung

#### [GH-2932]
*   Disable brittle test. thanks Paul Thornthwaite

#### [aws]
*   add mock tagging for acls and vpcs, refactor types. thanks Ben House
*   support `xvd` based devices (HVM). thanks Jason Hansen
*   update refs to ec2_compatibility_mode. thanks Michael Hale

#### [aws/security_group]
*   Support mock of group from another account. thanks Greg Burek

#### [aws|compute]
*   adding support for t2 instance class. thanks Yousef Ourabi

#### [aws|elb]
*   add support for ELB connection draining. thanks Blake Gentry
*   Fix tests so that they work with FOG_MOCK=false for both EC2-Classic and VPC style AWS accounts. thanks Michael Hale

#### [cloudsigma]
*   remove meaningless 'related' attribute type. thanks geemus

#### [dynect|dns]
*   Fixes exception behavior for 307's. thanks Nick Janus

#### [glesys]
*   API change, new attribute :bandwidth added. thanks  and Tomas Skogberg

#### [google | compute]
*   add google-containers project for images. thanks Eric Johnson

#### [google|compute]
*   remove hard-coded references to /projects/google/. thanks Eric Johnson
*   Some fixes for Images. thanks Ferran Rodenas
*   Improve Server support. thanks Ferran Rodenas
*   Enable passing the google key as a String. thanks Ferran Rodenas
*   Add disk_size_gb to 'Image' model. thanks Ferran Rodenas
*   Add DiskType resource. thanks Ferran Rodenas
*   Add support for DiskTypes in Disks. thanks Ferran Rodenas
*   Fix operations scopes for compute engine. thanks ashmrtnz

#### [misc]
*   remove :url param from get_service request for google storage. thanks  Lomoff
*   fix disks and servers live tests. thanks  Lomoff
*   remove some test output, add size_gb as a required field for disk creation. thanks  Lomoff
*   rewrite the way model is waited in live tests. thanks  Lomoff
*   fix asynchronious disks collection tests. thanks  Lomoff
*   fix object test (it already was shared object with such name somewhere). thanks  Lomoff
*   fix live tests for google engine. thanks  Lomoff
*   add new line to the end of google_tests_helper.rb. thanks  Lomoff
*   refactor to remove backoff-if-unfound function from google compute service. thanks  Lomoff
*   fix 1.8.7 compatibility. thanks  Lomoff
*   merge with master. thanks  Lomoff
*   one: changed name nic to interface. thanks ller
*   one server: added interfaces_attributes. thanks ller
*   one: added nil defaults for interfaces. thanks ller
*   one: added to_label to flavor. thanks ller
*   one: added vlan and to_label for network. thanks ller
*   one: added groupid for servers. thanks ller
*   one: raise one errors if vm allocation fails. thanks ller
*   Revert "[opennebula] ruby 1.8.7: add gem require_relativ". thanks ller
*   Move PrivateIpAddress to the NetworkInterface structure. thanks Andrew Hodges
*   Link catalog item to a catalog in Mock. thanks Anna Shipman
*   Add Mock for a vAppTemplate. thanks Anna Shipman
*   Add a Mock for post_instantiate_vapp_template. thanks Anna Shipman
*   Do not return a network from sample config. thanks Anna Shipman
*   Add Mock for put_memory. thanks Anna Shipman
*   Add Mock for put_vm. thanks Anna Shipman
*   Add Mock for put_cpu. thanks Anna Shipman
*   Add Mock for get_vapp_metadata. thanks Anna Shipman
*   Add Mock for put metadata. thanks Anna Shipman
*   Add Mock for get_vms_in_lease_from_query. thanks Anna Shipman
*   Add Mock for edgeGateway query. thanks Anna Shipman
*   Make name of network less generic. thanks Anna Shipman
*   Add Mock for orgVdc in get_execute_query. thanks Anna Shipman
*   Add support for tags for Data Pipeline. thanks Anthony Accardi
*   allow to instantiate template without network_id. thanks Barrett Jones
*   promote read replica test (pending), style cleanup. thanks Ben Chadwick
*   fix EngineVersion for PendingModifiedValues (plus minor cleanup). thanks Ben Chadwick
*   add tagSet to describe_network_acls. thanks Ben House
*   pass tags when creating network acl. thanks Ben House
*   remove tag setting from describe_network_acls. thanks Ben House
*   apply tag filters to network acls. thanks Ben House
*   add tests for acl tag filtering. thanks Ben House
*   clean up acl test tag. thanks Ben House
*   update delete_tags request to match create_tags. thanks Ben House
*   add tagging for vpcs. thanks Ben House
*   move tagged_resources method to compute. thanks Ben House
*   tag vpc after it is created. thanks Ben House
*   tag acl after it is created. thanks Ben House
*   merge tags if present, reset mocks after acl/vpc tests. thanks Ben House
*   promote read replicas. thanks Benjamin Chadwick
*   fix. thanks Benjamin Chadwick
*   fix parser. thanks Benjamin Chadwick
*   update to mocking code. thanks Benjamin Chadwick
*   rename Fog::Compute::OpenStack::Tenants#find_by_id to #get for consistency. thanks Brett Lentz
*   add ability to replace existing Dyn records. thanks Brett Lentz
*   Typo in fog.io link. thanks ltje
*   Content type to upload vAppTemplates is application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml'. thanks Daniel Aragao
*   Fixes attributes when generating xml body for post deploy vapps. thanks Daniel Aragao
*   Adds VPN section to edge gateway service configuration. thanks Daniel Aragao
*   Adds DHCP to edge gateway service configuration. thanks Daniel Aragao
*   Using end_point rather than static IP 10.194.1.65 on xsi. thanks Daniel Aragao
*   mock wasn't being set with FOG_MOCK env variable. thanks Daniel Aragao
*   updated regions list. thanks Dave Benvenuti
*   Behave more like DO when private_networking flag is passed in.  Include a private_ip_address in the response only if the region supports private networking. thanks Dave Benvenuti
*   fixed whitespace. thanks Dave Benvenuti
*   Fixing uniq_id issue with create_load_balancer mock. thanks Dejan Menges
*   Forgot to commit uniq_id. thanks Dejan Menges
*   Fixing uniq_id issue with create_load_balancer mock. thanks Dejan Menges
*   Forgot to commit uniq_id. thanks Dejan Menges
*   Deduplicating, using Fog::Mock.random_numbers(). thanks Dejan Menges
*   Add pretend networking and interface association to the network interface mocking. thanks Eric Herot
*   sub double for single quotes. thanks Eric Herot
*   Treat device index as string instead of int. thanks Eric Herot
*   Set instance vpcId based on subnet vpcId. thanks Eric Herot
*   More aggressively reset the mocking environment. thanks Eric Herot
*   Add ipaddress gem requirement. thanks Eric Herot
*   Add some line breaks to duplicate interface failure test. thanks Eric Herot
*   Reset mocking environment before acl test. thanks Eric Herot
*   Reset mocking environment in ELB model tests. thanks Eric Herot
*   Reset mocking environment in internet gateway tests. thanks Eric Herot
*   Reset mocking environment in route tests. thanks Eric Herot
*   Reset mock environment in assign private ip tests. thanks Eric Herot
*   Allow subnets with same CIDR but different IP (and test for it). thanks Eric Herot
*   support r3 instances & expose virtualization type. thanks Eugene Howe
*   properly initialize compute object inside elb methods. thanks Eugene Howe
*   fix for 1.8.7. thanks Eugene Howe
*   allow files in personality to have symbol keys. thanks Gabe Conradi
*   Use latest AWS EC2 API version. thanks Greg Burek
*   Adds encrypted EBS snapshots. thanks Greg Burek
*   Adds encrypted EBS volumes. thanks Greg Burek
*   Adds parsing for encrypted block devices to create_image. thanks Greg Burek
*   Adds comment about using encrypted flag with block device mapping on run_instances. thanks Greg Burek
*   Updates volume mocks to reflect new IOPs to size ratio of 30:1. thanks Greg Burek
*   Get to green. thanks Greg Burek
*   Correct AWS API version to one in the past. thanks Greg Burek
*   Full API coverage of the CloudStack 4.2.X API. thanks Jeff Moody
*   Updated to no longer change historical method signatures. thanks Jeff Moody
*   Add Fog::Compute.create_many and bootstrap_many. thanks John Keiser
*   Move save_many to servers, reuse save_many in save. thanks John Keiser
*   Fix describe_internet_gateways calls for >1 igw. thanks Jon Topper
*   AWS Ensure NetworkInterface model exposes private ip addresses. thanks Jonathan Serafini
*   AWS Ensure allocation_id is set on private ip address. thanks Jonathan Serafini
*   Add the DisableApiTermination flag to the AWS Server model, so it can be sent on instance creation. thanks Jordan Day
*   hardcoded linode flavor cores until they add it to their api. thanks Josh Blancett
*   update for new linode flavor ids. thanks Josh Blancett
*   add request for linode.config.delete. thanks Josh Blancett
*   add request for linode.config.update. thanks Josh Blancett
*   Denser code style. thanks Konstantinos Natsakis
*   Updated setup method to retry once on disconnect to try to address issues with Ubuntu 12.04 images. thanks Kyle Rames
*   rebasing with master. thanks Kyle Rames
*   Fix #2892: "rake travis" fails with can't modify frozen String. thanks Marcin Owsiany
*   Added ip_address methods consistent with openstack. thanks Marcus Nilsson
*   Add fog-softlayer module . thanks Matt Eldridge
*   Update links to DigitalOcean SSH-key docs. thanks Matthew Breeden
*   remove www subdomain from digital ocean ssh-key links. thanks Matthew Breeden
*   Support for required EvaluateTargetHealth for ALIAS records. thanks Matthew O'Riordan
*   took out os_account_meta_temp_url_key as a required parameter and marked it as deprecated.  this code does not belong in the hp provider. thanks Mike Hagedorn
*   added exception for using temp urls with no key. thanks Mike Hagedorn
*   Add basic mock data for vapp/vm. thanks Mike Pountney
*   add Mock for get_vapp. thanks Mike Pountney
*   extend get_vdc mock to return contained vApps. thanks Mike Pountney
*   add vApps-in-vDC support in Mock. thanks Mike Pountney
*   Add LeaseSettingSection Mocks for vApps. thanks Mike Pountney
*   Add Owner Mocks for vApps. thanks Mike Pountney
*   Add Mocks for VM VirtualHardwareSection GET methods. thanks Mike Pountney
*   Mock for get_snapshot_section. thanks Mike Pountney
*   Mock for get_network_connection_system_section_vapp. thanks Mike Pountney
*   Mock for get_operating_system_section. thanks Mike Pountney
*   Add Mock for get_startup_section. thanks Mike Pountney
*   Add (crap) Mock for get_network_config_section_vapp. thanks Mike Pountney
*   Add Mock for get_runtime_info_section_type. thanks Mike Pountney
*   Add Mock support in get_vm_capabilities. thanks Mike Pountney
*   Fix 1.8.7 bug - trailing comma in arg list. thanks Mike Pountney
*   Fix 1.8.7 bug - trailing comma in arg list. thanks Mike Pountney
*   Workaround for Hash.select in Ruby 1.8. thanks Mike Pountney
*   Remove coveralls. thanks Nat Welch
*   Remove coveralls from test helper. thanks Nat Welch
*   second attempt to fix issue# 2748, plus fix the same problem for the volume/s and spot request/s models as well. thanks Nathan Sullivan
*   Change signature of stop method. thanks Olle Lundberg
*   Add support for expunging node in cloudstack. thanks Olle Lundberg
*   Remove COVERAGE env setup on Travis. thanks Paul Thornthwaite
*   Add Rubocop and checklist. thanks Paul Thornthwaite
*   Guard Ruby 1.8.7 against Rubocop in short term. thanks Paul Thornthwaite
*   Standardise empty lines throughout codebase. thanks Paul Thornthwaite
*   Standardise indentation of access modifiers. thanks Paul Thornthwaite
*   Remove trailing blank lines. thanks Paul Thornthwaite
*   Remove trailing whitespace. thanks Paul Thornthwaite
*   Update rubocop todo list. thanks Paul Thornthwaite
*   Replace `alias` with `alias_method`. thanks Paul Thornthwaite
*   Standardise on collection methods. thanks Paul Thornthwaite
*   Replace deprecated File.exists? method. thanks Paul Thornthwaite
*   Replace deprecated Hash methods. thanks Paul Thornthwaite
*   Update rubocop todo list. thanks Paul Thornthwaite
*   Remove providers directory. thanks Paul Thornthwaite
*   Remove edge check for fog-brightbox. thanks Paul Thornthwaite
*   Make job polling requests for Dyn retryable within exconn by passing the idempotent option. thanks Peter Drake
*   initial opennebula fog class and directories. thanks Sebastian Saemann
*   dynect: dns: dramatically improve speed of 'get_all_records' request and 'records.all' method. thanks Shawn Catanzarite
*   Add custom_fields support to vcloud_director. thanks Simas Cepaitis
*   Fix typo. thanks Simas Cepaitis
*   Add custom_fields to vapp, remove debug info. thanks Simas Cepaitis
*   Add couple of functions and tests. thanks Simas Cepaitis
*   Rename method to put_product_sections and update it's documentation. thanks Simas Cepaitis
*   Add custom_fields support to vcloud_director. thanks Simas Cepaitis
*   Fix typo. thanks Simas Cepaitis
*   Add custom_fields to vapp, remove debug info. thanks Simas Cepaitis
*   Add couple of functions and tests. thanks Simas Cepaitis
*   Rename method to put_product_sections and update it's documentation. thanks Simas Cepaitis
*   remove :host from request parameters, stopping excon errors. thanks Tom Armitage
*   Add options support. thanks Tom Noonan II
*   Add options argument to all() method. thanks Tom Noonan II
*   Add pagination markers (#2908). thanks Tom Noonan II
*   Fix variable name error. thanks Tom Noonan II
*   Resolve copypasta error. thanks Tom Noonan II
*   Resolve issue where metadata was being discarded too early. thanks Tom Noonan II
*   Create volume in specific availability zone. thanks sig
*   remove jekyll dependency. thanks geemus
*   allow 1.8.7 failures. thanks geemus
*   remove duplication in fog/xml connection stuff. thanks geemus
*   fix 2.1.1 syntax error with updated attributes. thanks geemus
*   bump fog-core dep. thanks geemus
*   remove explicit call for 'type' hash, fallback to default. thanks geemus
*   fix erroneous date_time type. thanks geemus
*   Update create_server.rb. thanks georgyous
*   pass options to zerigo list_hosts. thanks joe morgan
*   Add options for listing hosts     Options include     - Per_page     - Page     - FQDN. thanks joe morgan
*   update styling per rubocop. thanks joe morgan
*   update indentation. thanks joe morgan

#### [opennebula]
*   adapted the new require structure and added uuid for server model. thanks ller
*   removed debug infos. thanks ller
*   raise an ArgumentError if VM name is empty/nil. thanks ller
*   add gem dependencies and require. thanks ller
*   add vm_allocate and network tests. thanks ller
*   make one provider available to fog. thanks ller
*   added README and some examples for opennebula provider. thanks ller
*   Added several mocks for fit live testing. thanks ller
*   fixed indentation and changed string interpolation. thanks ller
*   typo in raise. thanks ller
*   interface model: attributes are nil by default; added persisted?. thanks ller
*   network model: removed default definition of attribute description. thanks ller
*   fixed indentation. thanks ller
*   VNC console cleanup. thanks ller
*   fixed indentation. thanks ller
*   interface model: added method persisted?. thanks ller
*   server model: comments and rename of methods (for compability to foreman). thanks ller
*   removed opennebula dependecies. thanks ller
*   gemspec: moved opennebula to  development_dependency. thanks ller
*   fixed indentation. thanks ller
*   add credentials to mock_helper. thanks ller
*   ruby 1.8.7: add gem require_relativ. thanks ller
*   fix link in readme. thanks ller
*   VNC: require local file compatible to ruby 1.8.7. thanks ller
*   flavor model: minor simplifications. thanks ller
*   fixed indentations. thanks ller
*   model flavor: lowercase attributes. thanks ller
*   added groups.get and groups.get_by_name filters. thanks ller
*   added flavors.get_by_name. thanks ller
*   code cleanup, indentations. thanks ller
*   use flavors.get_by_name for live tests. thanks ller
*   clean up and code simplification. thanks ller
*   use id instead of uid for groups. thanks ller
*   interface: use persisted? instead of new?; remove constructor. thanks ller
*   use id instead of uuid for network. thanks ller
*   network tests: use id not uuid. thanks ller
*   Added live/mock tests for group/s. thanks ller
*   network: removed unnecessary constructor. thanks ller
*   fix for #3003 - soft load the opennebula gem. thanks ller

#### [openstack | server]
*   start/stop/pause/suspend actions. thanks Marek Kasztelnik

#### [openstack|compute]
*   added descriptions to returns blocks in the security_groups tests in hopes of trying to track down the cause of issue #2874. thanks Kyle Rames

#### [openstack|storage]
*    fixing bug metadata indifferent access implementation. thanks Kyle Rames

#### [ovirt]
*   force volumes reload on volume locked? check. thanks Amos Benari

#### [rackspace]
*   updating authentication endpoints. thanks Kyle Rames

#### [rackspace|autoscale]
*   fixing typo in docs. thanks Kyle Rames
*   call clear on collection if group has not been persisted in order to prevent fog from lazy loading non-existent collections. thanks Kyle Rames
*   updating getting started docs. thanks Kyle Rames
*   fixing broken tests. thanks Kyle Rames

#### [rackspace|compute_v2]
*   escaping flavor_id and image_id in get operations. thanks Kyle Rames

#### [rackspace|load balancers]
*   updating node handling so it is similar to PR#3010. thanks Kyle Rames

#### [rackspace|loadbalancers]
*   updated code so that you did not need to pass nodes in during load balancer creation. thanks Kyle Rames
*   updated to only call clear on newly created nodes and access rule collections for unpersisted load balancers. thanks Kyle Rames
*   The id, and ipVersion were not being populated when making a create load balancer call. Fixes #3008. thanks Kyle Rames

#### [rackspace|storage]
*   made the index operator use indifferent access in order to fix issue #2881. thanks Kyle Rames

#### [stormondemand|dns]
*   fixing typo in require statement. thanks Kyle Rames

#### [vcloud_director]
*   Add :put_network request. thanks Mike Pountney
*   missing post_capture_vapp functionality. thanks Nick Osborn
*   Implement post_create_catalog_item. thanks Nick Osborn
*   gateway should be nullable in network. thanks geemus
*   allow nullable FenceMode. thanks geemus

#### [vsphere]
*   Fixed bug in which clients are forced to wait for instance.     The 'wait' option was being forced to true in clone_vm. thanks Cyrus Team
*   Fixed bug in which clients are forced to wait for instance.     The 'wait' option was being forced to true in clone_vm. thanks Cyrus Team
*   expose VM virtual hardware version. thanks Michael Moll
*   Remove the relative_path attribute. thanks Timur Alperovich
*   Use the server_id in interfaces. thanks Timur Alperovich
*   Use server_id in the Volumes collection. thanks Timur Alperovich

#### [zerigo]
*   Fix Invalid Excon request warning. thanks Phil Kates


## 1.22.1 05/29/2014
*Hash* ca603769c940481885d60cda68288eb124c49cd6

Statistic     | Value
------------- | --------:
Collaborators | 30
Downloads     | 5483958
Forks         | 1181
Open Issues   | 180
Watchers      | 3056

**MVP!** Ferran Rodenas

#### [GH-2873]
*   Ensure fog is using fog-core 1.22+. thanks Paul Thornthwaite

#### [google|compute]
*   Add Region tests. thanks Ferran Rodenas
*   Update Images support. thanks Ferran Rodenas
*   Update Servers support. thanks Ferran Rodenas
*   Improve Disks support. thanks Ferran Rodenas
*   Update Addresses suport. thanks Ferran Rodenas

#### [misc]
*   Enabled :path_style for Google Cloud Storage for allowing CNAME buckets. thanks Romain Haenni


## 1.22.0 04/17/2014
*Hash* 6d2c2d0575f9f7337bd01d17428dc12b7105329a

Statistic     | Value
------------- | --------:
Collaborators | 30
Downloads     | 5038529
Forks         | 1145
Open Issues   | 157
Watchers      | 2992

**MVP!** Benson Kalahar

#### [Brightbox]
*   Update testing to MiniTest::Spec. thanks Paul Thornthwaite
*   Test error when required args missing. thanks Paul Thornthwaite

#### [GH-1390]
*   Remove redundant calls to Fog.credentials. thanks Paul Thornthwaite

#### [GH-2793]
*   Exclude examples from documented methods. thanks Paul Thornthwaite

#### [OpenStack]
*   Use JSON instead of XML. thanks Evan Light

#### [Rackspace]
*   Remove circular requires from Storage. thanks Paul Thornthwaite

#### [Rackspace|Monitoring]
*   Add disabled flag to alarm.  Fixes issue #2731. thanks rebelagentm

#### [Vsphere]
*   Isolate helper from core. thanks Paul Thornthwaite

#### [core]
*   Remove providers/ directory from core fog gem. thanks Dominic Cleal
*   converted changelog to markdown format. thanks Kyle Rames
*   updated rake releases to generate markdown; added github_release task to publish to release feed. thanks Kyle Rames
*   tweaking per @icco; fixing broken build. thanks Kyle Rames
*   fixing gemspec for 1.8.7. thanks Kyle Rames
*   locking rbovirt down to version 0.0.24 as the newly released 0.0.25 had broken some of our tests. thanks Kyle Rames

#### [ecloud]
*   adding :base_path as recognized parameter. thanks Kyle Rames

#### [fog-brightbox]
*   Prepare for v0.0.2 release. thanks Paul Thornthwaite
*   Correct CHANGELOG categories. thanks Paul Thornthwaite

#### [google]
*   fixes set_tags. thanks Eric Johnson
*   fix service_account scopes. thanks Eric Johnson

#### [google|compute]
*   allow user to set disk description. thanks Eric Johnson
*   adding automaticRestart and onHostMaintenance. thanks Eric Johnson
*   fix instance tags and remove zone lookup call. thanks Eric Johnson
*   Add Projects support. thanks Ferran Rodenas
*   Modify Flavors. thanks Ferran Rodenas
*   Complete Operations support. thanks Ferran Rodenas
*   Modify Snapshots. thanks Ferran Rodenas
*   Add Firewalls support. thanks Ferran Rodenas
*   Add Addresses support. thanks Ferran Rodenas
*   Add Networks support. thanks Ferran Rodenas
*   Add Routes support. thanks Ferran Rodenas
*   Add Regions support. thanks Ferran Rodenas
*   Make destroy methods consistent. thanks Nat Welch
*   Update default zone and image. thanks Nat Welch
*   Also tweak default disk in tests. thanks Nat Welch

#### [joyent|compute]
*   Added attributes to cloudapi responses recently to servers, Closes #2800. thanks Kevin Chan

#### [misc]
*   Allow auth URLs without a trailing slash. thanks Abhishek Chanda
*   Spelling, trailing whitespace. thanks Ash Wilson
*   Include the port in temp_url if necessary. thanks Ash Wilson
*   Use URI::Generic.build to build the URI, instead. thanks Ash Wilson
*   Test the relevant bits of the temp_urls explicitly. thanks Ash Wilson
*   Refactor out common bits from temp_url tests. thanks Ash Wilson
*   Fix get_object_http_url, too. thanks Ash Wilson
*   One less extraneous whitespace change. thanks Ash Wilson
*   Apply the pending modifier before Storage.new. thanks Ash Wilson
*   adding #all! to Fog::DNS::Rackspace::Records to load in all records for a zone (max 500 with Rackspace). thanks Ben Hundley
*   replacing #all! in Fog::DNS::Rackspace::Records with pagination in #each. thanks Ben Hundley
*   Adds first cut of GCE http health checks. thanks Benson Kalahar
*   @icco still can't spell. thanks Benson Kalahar
*   Adds target pools. thanks Benson Kalahar
*   Adds forwarding rules. It is possible to set up a load balancer. thanks Benson Kalahar
*   Removed questionably trustworthy mocking code. thanks Benson Kalahar
*   Also removed untrustworthy region operation mock. thanks Benson Kalahar
*   Adds load balancer example, and fixes http_health_check bug. thanks Benson Kalahar
*   Makes sleep before deleting disks longer to be safe. thanks Benson Kalahar
*   Cleans up load balancer example. thanks Benson Kalahar
*   Adds support for changing forwarding rule targets. thanks Benson Kalahar
*   It might work. thanks Benson Kalahar
*   Removes modification, instead relying on reload. thanks Benson Kalahar
*   Makes disk delete optionally async. thanks Benson Kalahar
*   Cloudstack servers get function will now find VM in projects for normal     users. thanks Carl Loa Odin
*   fixed misspelling. thanks Christian Berendt
*   few minor fixes. thanks Eric Johnson
*   another quick fix. thanks Eric Johnson
*   fix destroy and add ready?, other little cleanups. thanks Eric Johnson
*   Replaces Fog::XML::Connection with Fog::Core::Connection so as to use     JSON again instead of wrongly using XML. thanks Evan Light
*   Improve checking for Cloud Queue message IDs. thanks  Ollie
*   don't use named capture groups for ruby 1.8.7 compatibility. thanks  Ollie
*   Adding support for IAM roles and STS in the AWS::IAM service. thanks Joshua Garnett
*   Adding refresh_credentials_if_expired to IAM#request. thanks Joshua Garnett
*   Adding support for AWS IAM ListMFADevices API. thanks Joshua Garnett
*   Adding a unit test for list_mfa_devices.  Also, fixed parsing of EnableData to use Time.parse. thanks Joshua Garnett
*   Adding support for udplimit paramater in rage4 api. thanks Joshua Gross
*   making tests ruby 1.8.7 friendly. thanks Joshua Gross
*   Fix issue #2796 (AWS describe_dhcp_options request parsing). thanks Konstantinos Natsakis
*   Correctly index SecurityGroupId parameter when it is inside a NetworkInterfaces hash. thanks Kunal Thakar
*   rebasing with master. thanks Kyle Rames
*   adding github_release dependency to edge gemfile. thanks Kyle Rames
*   Fix syntax errors in an OpenStack example script. thanks Larry Gilbert
*   The server password (adminPass) should can be set during server creation. thanks Max Lincoln
*   The password attribute doesn't like the use of @password. thanks Max Lincoln
*   info is now called json. thanks Michael Sprauer
*   fixed examples for HPC access. thanks Mike Hagedorn
*   Fix build broken by 96a56b954eec6c2e93e0b9f696bed08c8414d1d7. thanks Nat Welch
*   Fix Disk tests. thanks Nat Welch
*   Lists disks isn't a valid test since response varies greatly by disk. thanks Nat Welch
*   Removed unicode NFC normalization of S3 object keys. thanks Nathan Sutton
*   Lock rake to 10.1 for Ruby 1.8.7. thanks Paul Thornthwaite
*   Move 1.8.7's Gemfile for subdirectory. thanks Paul Thornthwaite
*   Fix reference to fog's gemspec. thanks Paul Thornthwaite
*   Test the latest edge version of fog and parts. thanks Paul Thornthwaite
*   Switch testing to MiniTest::Spec. thanks Paul Thornthwaite
*   Remove deprecated `host` Excon option from dynamodb. thanks Pedro Belo
*   . fix ruby-libvirt library require name (libvirt). thanks Reda NOUSHI
*   Add the ability to pass an options Hash to DataPipeline#describe_objects. thanks Tom Hulihan
*   fix documentation of unmounting volumes. thanks Toni Stjepanovic
*   Allow v2 authentication url with trailing slash. thanks nis Simo
*   ISSUE-2824 Adding user_data to rackspace provider. thanks Yann Hamon

#### [openstack|network]
*   updated create_router and update_router use symbol based keys instead of string; removed dead code; this should address #2799. thanks Kyle Rames
*   fixing broken tests. thanks Kyle Rames
*   fixing broken tests; added deprecation warning about removing support for passing model objects into the request layer. thanks Kyle Rames
*   taking another shot at repairing a broken test. thanks Kyle Rames

#### [openstack|networking]
*   fixing tests. thanks Kyle Rames

#### [vcloud_director]
*   fix progress reporting of tasks without progress. thanks Dan Abel

#### [vsphere]
*   check for string true/false instead of boolean. thanks geemus


## 1.21.0 03/18/2014
*Hash* c9dfbd5b4d3687b5c809f6617ba9a5454a2a9c49

Statistic     | Value
------------- | --------:
Collaborators | 55
Downloads     | 4751224
Forks         | 1116
Open Issues   | 148
Watchers      | 2959

**MVP!** Kevin Olbrich

#### [AWS | Compute]
*   Validate region. *thanks radekg*

#### [AWS | Compute | incorrect_region]
*   Corrected test name. *thanks radekg*

#### [AWS/elasticache]
*   Added mocking for parameter groups. *thanks Brian Nelson*
*   Minor fix from RDS copy/pasta. *thanks Brian Nelson*

#### [AWS/vpc]
*   Fix VPC creation mock. *thanks Brian Nelson*

#### [Brightbox]
*   Replace use of Fog::Connection. *thanks Paul Thornthwaite*
*   Destroy snapshot after completion. *thanks Paul Thornthwaite*
*   Remove SQL instance snapshot attr. *thanks Paul Thornthwaite*
*   Support Cloud SQL maintenance windows. *thanks Paul Thornthwaite*
*   Require `fog/json` in compute. *thanks Paul Thornthwaite*
*   Extract to provider module. *thanks Paul Thornthwaite*
*   Add support for Cloud SQL service. *thanks Paul Thornthwaite*
*   Remove old #destroy request. *thanks Paul Thornthwaite*
*   Don't set generic names in tests. *thanks Paul Thornthwaite*
*   Fix SQL instance waiting in tests. *thanks Paul Thornthwaite*
*   Round out fog-brightbox gem. *thanks Paul Thornthwaite*
*   Use minitest in Brightbox module. *thanks Paul Thornthwaite*
*   Remove dependency on .fog in test. *thanks Paul Thornthwaite*

#### [DigitalOcean]
*   Skip consistently timing out tests. *thanks Paul Thornthwaite*

#### [Docker]
*   fixed attributes aliases. *thanks Amos Benari*
*   fixes running state is not loaded,     becase list-containers get only part of the container attributes. *thanks Amos Benari*
*   camelize hash keys on image and container create. *thanks Amos Benari*
*   container actions fixed. *thanks Amos Benari*

#### [GH-2630]
*   Bring in Minitest. *thanks Paul Thornthwaite*

#### [GH-2706]
*   Update ruby-libvirt dependency to 0.5. *thanks Paul Thornthwaite*

#### [GH-2711]
*   Add Fog::XML::Connection. *thanks Paul Thornthwaite*
*   Replace Fog::Connection with XML shim. *thanks Paul Thornthwaite*

#### [Openstack|Volumes]
*   available? check method. *thanks Daniel Lobato*

#### [README]
*   Add RightScale maintainer info (acu85381). *thanks kbockmanrs*

#### [aws]
*   fix race condition in v4 signature tests. *thanks geemus*

#### [aws/compute]
*   delete_security_group mock fixes. *thanks Josh Lane & Thom Mahoney*

#### [aws/security_group]
*   update mock search and revoke. *thanks Josh Lane & Thom Mahoney*

#### [aws|dns]
*   omit ttl for alias records. *thanks geemus*

#### [aws|iam]
*   Add get_account_summary. *thanks Dan Peterson*

#### [aws|region validation]
*   Region validation extracted into a separate class and used by both, mocks and real. *thanks radekg*
*   Error message of the test to match error of the validator. *thanks radekg*

#### [core]
*   Use fog-core v1.21.0. *thanks Paul Thornthwaite*
*   Make the wait timeout truly global. *thanks Paul Thornthwaite*
*   Replace Fog::Connection with stable version. *thanks Paul Thornthwaite*
*   Deprecate Fog::Connection. *thanks Paul Thornthwaite*
*   Fix deprecated Mintest base. *thanks Paul Thornthwaite*

#### [docker]
*   added command attribute. *thanks Amos Benari*

#### [google]
*   Don't swallow google errors in images.get. *thanks Carlos Sanchez*

#### [google|compute]
*   Changes to how auth works. *thanks Nat Welch*
*   Fix spelling errors in example. *thanks Nat Welch*
*   Use a valid image for v1 in example. *thanks Nat Welch*
*   Change projects we search for images in. *thanks Nat Welch*
*   reraise LoadError when google-api-client missing. *thanks geemus*
*   disk model: get_object fix for Ruby 1.8. *thanks kbockmanrs*
*   disk model: Add auto_delete option to get_as_boot_disk. *thanks kbockmanrs*
*   disk model: Default get_object auto_delete to false. *thanks kbockmanrs*

#### [internetarchive]
*   Correct test tagging. *thanks Paul Thornthwaite*

#### [libvirt|compute]
*   Allow volumes to be cloned at the disk level. *thanks Greg Sutcliffe*
*   Handle integer capacities. *thanks Greg Sutcliffe*

#### [misc]
*   added docker support. *thanks Amos Benari*
*   extended the server (container) attributes. *thanks Amos Benari*
*   added container commit request and fixed several tests in real mode. *thanks Amos Benari*
*   initial commit of changes to add network interface during instance creation. *thanks Andrew Stangl*
*   merge upstream changes. *thanks Andrew Stangl*
*   make sure mock creates interface that doesn't already exist. *thanks Andrew Stangl*
*   initial commit of changes to add network interface during instance creation. *thanks Andrew Stangl*
*   make sure mock creates interface that doesn't already exist. *thanks Andrew Stangl*
*   initial commit of changes to add network interface during instance creation. *thanks Andrew Stangl*
*   make sure mock creates interface that doesn't already exist. *thanks Andrew Stangl*
*   merge upstream changes from fog/master. *thanks Andrew Stangl*
*   merge changes from master. *thanks Andrew Stangl*
*   ensure correct type for networkInterface present for run_instances shindo tests. *thanks Andrew Stangl*
*   change naming to specify what the request is expecting - plural of networkInterfaces vs networkInterface. *thanks Andrew Stangl*
*   revert alias for networkInterfaces to original. *thanks Andrew Stangl*
*   revert alias for networkInterfaces to original. *thanks Andrew Stangl*
*   more changes to ensure networkInterfaces is referenced as a plural, which is what the API is expecting. *thanks Andrew Stangl*
*   merge upstream fog/master. *thanks Andrew Stangl*
*   merge upstream changes from fog/master. *thanks Andrew Stangl*
*   ensure options hash is actually passed to request. *thanks Andrew Stangl*
*   change security group return object to match actual returned object. *thanks Andrew Stangl*
*   Use case-insensitive header access for Location. *thanks Ash Wilson*
*   Fix case sensitivity of the Content-type header. *thanks Ash Wilson*
*   ability to supply serviceAccounts on image create. *thanks Brett Porter*
*   Update Amazon instance flavors. *thanks Chris Kershaw*
*   Fix syntax issue. *thanks Chris Kershaw*
*   Fix syntax issue. *thanks Chris Kershaw*
*   Correct another syntax issue. *thanks Chris Kershaw*
*   Add cpu_speed to flavors. *thanks Chris Kershaw*
*   Revert excon version back. *thanks Chris Kershaw*
*   Add cpu_speed to flavors. *thanks Chris Kershaw*
*   Add cpu_speed to flavors. *thanks Chris Kershaw*
*   Allow dnsimple authentication via API tokens. *thanks Chris Roberts*
*   Fix a typo in error message that could cause problems for cut-n-pasters. *thanks Christopher Snell*
*   Mock out the attachment of network interfaces. *thanks Eric Herot*
*   Remove debug code. *thanks Eric Herot*
*   set custom application/version for google compute. *thanks Eric Johnson*
*   use custom and fog user agent. *thanks Eric Johnson*
*   fix mismatched variable names in disk.create_snapshot. *thanks Eric Johnson*
*   Include auto-assigned IPs in public IP's. *thanks Erik Mackdanz*
*   sort array to avoid extraneous arrays. *thanks Erik Mackdanz*
*   Fix test. *thanks Erik Mackdanz*
*   Incorrectly requiring all of fog here. *thanks Evan Light*
*   Update getting_started.md. *thanks Evan Light*
*   Update to attempt to alleviate confusion between Directory.new and get. *thanks Evan Light*
*   Removing superfluous markup. *thanks Evan Light*
*   Incorporated feedback from `@mikhailov.` *thanks Evan Light*
*   Update Flavours.rb with new M3 Instance Types. *thanks Gaurish Sharma*
*   Don't read entire file into memory when saving to local blob storage. (local files). *thanks Jamie Paton*
*   Namespace File. *thanks Jamie Paton*
*   Creates error for early termination from vcloud. *thanks Jim Berlage*
*   Fixes class of error. *thanks Jim Berlage*
*   Return empty set on route53 if no records match. *thanks Jose Luis Salas*
*   add config_disk attribute to rackspace compute_v2 server. *thanks Joseph Anthony Pasquale Holsten*
*   fix typo. *thanks Joseph Anthony Pasquale Holsten*
*   add ipv6_only support to blue box. *thanks Josh Kalderimis*
*   some ipv6_only corrections. *thanks Josh Kalderimis*
*   Fixing [excon][WARNING] Invalid Excon request keys log noise when trying to use STS. *thanks Joshua Garnett*
*   This reverts our local modifications to fog gem. *thanks Kevin Olbrich*
*   add option :joyent_keydata.  This allows the key to be read from a file outside of Fog and be passed into the initializer.  This way the key data can be stored in something other than a file and still be used. *thanks Kevin Olbrich*
*   Basic analytics support including a class for joyent 'modules'.  Note that these are named 'JoyentModule' instead of 'Module' to avoid obvious namespace problems. *thanks Kevin Olbrich*
*   describe analytics support. *thanks Kevin Olbrich*
*   add support for 'metrics'. *thanks Kevin Olbrich*
*   metrics and fields. *thanks Kevin Olbrich*
*   fields. *thanks Kevin Olbrich*
*   add 'types'. *thanks Kevin Olbrich*
*   more types. *thanks Kevin Olbrich*
*   add transformations. *thanks Kevin Olbrich*
*   transformations. *thanks Kevin Olbrich*
*   memoize describe analytics call.  It doesn't change much and this prevents another api call for each of the objects returned by it. *thanks Kevin Olbrich*
*   add support for getting 'instrumentations'. *thanks Kevin Olbrich*
*   create instrumentations, handle errors better, get an individual instrumentation. *thanks Kevin Olbrich*
*   more instrumentation stuff. *thanks Kevin Olbrich*
*   allow creation and deletion of instrumentations. *thanks Kevin Olbrich*
*   delete an instrumentation. *thanks Kevin Olbrich*
*   Allow setting an attribute type of :timestamp.  Models using this type of attribute should receive times encoded as unix timestamps. *thanks Kevin Olbrich*
*   map internal attribute names to those used on the remote service before making api call to persist the data. *thanks Kevin Olbrich*
*   implement get_images api call. *thanks Kevin Olbrich*
*   implement get_image api call. *thanks Kevin Olbrich*
*   create an instrumentation via api call with start and end times. *thanks Kevin Olbrich*
*   add support for getting values from an instrumentation. *thanks Kevin Olbrich*
*   actually get the values. *thanks Kevin Olbrich*
*   documentation. *thanks Kevin Olbrich*
*   update compute with some attributes from api 7.0. *thanks Kevin Olbrich*
*   pull duration for value calls from instrumentation granularity so that things come back correctly from joyent. *thanks Kevin Olbrich*
*   add datacenter model. *thanks Kevin Olbrich*
*   perhaps make more threadsafe. *thanks Kevin Olbrich*
*   add mutex to real class instead of mock. *thanks Kevin Olbrich*
*   add tests for instrumentations. *thanks Kevin Olbrich*
*   more tests for instrumentations. *thanks Kevin Olbrich*
*   instrumentation collection tests. *thanks Kevin Olbrich*
*   mock instrumentation values. *thanks Kevin Olbrich*
*   tests for fields and describe analytics requests. *thanks Kevin Olbrich*
*   tests for joyent_modules. *thanks Kevin Olbrich*
*   tests for fields and joyent_module. *thanks Kevin Olbrich*
*   add tests for metrics, types and a few other things. *thanks Kevin Olbrich*
*   Revert "Add cpu_speed to flavors". *thanks Kevin Olbrich*
*   remove some comments. *thanks Kevin Olbrich*
*   properly use remap_attributes.  just do it for the outgoing request, don't permanently change them. *thanks Kevin Olbrich*
*   use Excon's idempotent option for gets and lists. *thanks Kevin Olbrich*
*   add option :joyent_keydata.  This allows the key to be read from a file outside of Fog and be passed into the initializer.  This way the key data can be stored in something other than a file and still be used. *thanks Kevin Olbrich*
*   Basic analytics support including a class for joyent 'modules'.  Note that these are named 'JoyentModule' instead of 'Module' to avoid obvious namespace problems. *thanks Kevin Olbrich*
*   describe analytics support. *thanks Kevin Olbrich*
*   add support for 'metrics'. *thanks Kevin Olbrich*
*   metrics and fields. *thanks Kevin Olbrich*
*   fields. *thanks Kevin Olbrich*
*   add 'types'. *thanks Kevin Olbrich*
*   more types. *thanks Kevin Olbrich*
*   add transformations. *thanks Kevin Olbrich*
*   transformations. *thanks Kevin Olbrich*
*   memoize describe analytics call.  It doesn't change much and this prevents another api call for each of the objects returned by it. *thanks Kevin Olbrich*
*   add support for getting 'instrumentations'. *thanks Kevin Olbrich*
*   create instrumentations, handle errors better, get an individual instrumentation. *thanks Kevin Olbrich*
*   more instrumentation stuff. *thanks Kevin Olbrich*
*   allow creation and deletion of instrumentations. *thanks Kevin Olbrich*
*   delete an instrumentation. *thanks Kevin Olbrich*
*   Allow setting an attribute type of :timestamp.  Models using this type of attribute should receive times encoded as unix timestamps. *thanks Kevin Olbrich*
*   map internal attribute names to those used on the remote service before making api call to persist the data. *thanks Kevin Olbrich*
*   implement get_images api call. *thanks Kevin Olbrich*
*   implement get_image api call. *thanks Kevin Olbrich*
*   create an instrumentation via api call with start and end times. *thanks Kevin Olbrich*
*   add support for getting values from an instrumentation. *thanks Kevin Olbrich*
*   actually get the values. *thanks Kevin Olbrich*
*   documentation. *thanks Kevin Olbrich*
*   update compute with some attributes from api 7.0. *thanks Kevin Olbrich*
*   pull duration for value calls from instrumentation granularity so that things come back correctly from joyent. *thanks Kevin Olbrich*
*   add datacenter model. *thanks Kevin Olbrich*
*   perhaps make more threadsafe. *thanks Kevin Olbrich*
*   add mutex to real class instead of mock. *thanks Kevin Olbrich*
*   add tests for instrumentations. *thanks Kevin Olbrich*
*   more tests for instrumentations. *thanks Kevin Olbrich*
*   instrumentation collection tests. *thanks Kevin Olbrich*
*   mock instrumentation values. *thanks Kevin Olbrich*
*   tests for fields and describe analytics requests. *thanks Kevin Olbrich*
*   tests for joyent_modules. *thanks Kevin Olbrich*
*   tests for fields and joyent_module. *thanks Kevin Olbrich*
*   add tests for metrics, types and a few other things. *thanks Kevin Olbrich*
*   Revert "Add cpu_speed to flavors". *thanks Kevin Olbrich*
*   remove some comments. *thanks Kevin Olbrich*
*   properly use remap_attributes.  just do it for the outgoing request, don't permanently change them. *thanks Kevin Olbrich*
*   use Excon's idempotent option for gets and lists. *thanks Kevin Olbrich*
*   change ruby 1.9.3 style hashes to ruby 1.8.7 style for backwards compatability. *thanks Kevin Olbrich*
*   Added find_by_name to openstack identity-users model and tests. *thanks Markus Schwed*
*   Fix exception if listing raw vSphere volumes (thinProvisioned method missing). *thanks Martin Matuska*
*   support pagination of results in AWS Data Pipeline query_objects. *thanks Matt Gillooly*
*   Support VPC security group modifictions for RDS. *thanks Mike Marion*
*   Add network model tests. *thanks Mike Pountney*
*   Use admin endpoint for get_network. *thanks Mike Pountney*
*   Switch network model over to get_network_complete. *thanks Mike Pountney*
*   Add Mock support to get_network_complete. *thanks Mike Pountney*
*   Add deprecation warning for get_network. *thanks Mike Pountney*
*   Fix Ruby 1.8.7 hash key issue. *thanks Mike Pountney*
*   Allow for specification of vcloud_token via ENV. *thanks Mike Pountney*
*   Add fence_mode to network model. *thanks Mike Pountney*
*   Ensure get_network_complete mock returns like API. *thanks Mike Pountney*
*   Add is_shared attribute to network Model. *thanks Mike Pountney*
*   An attempt at an example. *thanks Nat Welch*
*   Fix some bugs with GCE auth refactoring. *thanks Nat Welch*
*   Fixes some bugs found in GCE examples. *thanks Nat Welch*
*   Fix some last bugs in gettng new google_client abstraction working. *thanks Nat Welch*
*   Tweak gemspec to be less specific for certain gems. *thanks Nat Welch*
*   Fix Joyent service declarations. *thanks Paul Thornthwaite*
*   Changes to rely on fog-core. *thanks Paul Thornthwaite*
*   Use fog-json. *thanks Paul Thornthwaite*
*   Move services to fog-core. *thanks Paul Thornthwaite*
*   Remove duplicate requires from services. *thanks Paul Thornthwaite*
*   Exclude the duplicated Ruby v2.1.0 run. *thanks Paul Thornthwaite*
*   Remove testing for 1.9.2. *thanks Paul Thornthwaite*
*   Exclude the duplicated Ruby v2.1.0 run (v2). *thanks Paul Thornthwaite*
*   Set fast_finish on Travis CI. *thanks Paul Thornthwaite*
*   Remove trailing whitespace. *thanks Paul Thornthwaite*
*   Require `json` or `xml` in provider cores. *thanks Paul Thornthwaite*
*   Add Ruby 2.1.1 to testing matrix. *thanks Paul Thornthwaite*
*   Revert "[core] Replace Fog::Connection with stable version". *thanks Paul Thornthwaite*
*   Make Coveralls opt-in. *thanks Paul Thornthwaite*
*   Reduce size of Travis matrix. *thanks Paul Thornthwaite*
*   Revert to original .travis.yml and include one case. *thanks Paul Thornthwaite*
*   Rename testing class to fit filename. *thanks Paul Thornthwaite*
*   Minitest picks up tests in provider modules. *thanks Paul Thornthwaite*
*   Added tablet device to default template to fix VNC and Mouse pointer position. *thanks Ryan Davies*
*   Adding S3 snapshot location for elasticache. *thanks Scott Carleton*
*   Add a private IP by default to the openstack server mock. *thanks Trae Robrock*
*   Add attribute firewall_policy to nic. *thanks dJason*
*   Add ready? to server class. *thanks dJason*
*   Mark servers collection tests as pending. *thanks dJason*
*   add fog-core to 1.8.7 Gemfile also. *thanks geemus*
*   simplify travis.yml to just use explicit includes. *thanks geemus*
*   bump rbovirt dependency. *thanks geemus*
*   bump excon dependency. *thanks geemus*
*   defer fog-core deps to fog-core. *thanks geemus*
*   bump fog-core dep. *thanks geemus*
*   add ability to assocation address to private ip address. *thanks joe*
*   updated documentation for associate_address. *thanks joe*
*   Take hash as argument for associate address     Left check for backwards compatability. *thanks joe*
*   Add tests to check argument structure for associate address     Updated other test to take hash. *thanks joe*
*   add ability to assocation address to private ip address. *thanks joe*
*   updated documentation for associate_address. *thanks joe*
*   Take hash as argument for associate address     Left check for backwards compatability. *thanks joe*
*   Add tests to check argument structure for associate address     Updated other test to take hash. *thanks joe*
*   change documentation typo. *thanks joe*
*   remove add nils and remove array merge. *thanks joe*
*   update mock to match real. *thanks joe*
*   Update mock for instance_id and allocation_id     Adds error checking for instance_id/network_interfrace     Adds error checkoing for public_ip or allocation_id. *thanks joe morgan*
*   [google][compute] auth needs additional scope to insert images. *thanks kbockmanrs*
*   Added a fingerprint parameter to set_metadata request, since without this property the request with 'CONDITION_NOT_MET' status. *thanks leonidlm*
*   Switched places between the optional arguments for the set_metadata request on google provider to support older ruby versions. *thanks leonidlm*
*   1. Added the fingerprint parameter to the set_metadata mock definition     2. Added comments to set_metadata to clarify how the fingerprint parameter can be generated. *thanks leonidlm*
*   don't require service when registering it - matches commit https://github.com/fog/fog/commit/f9a5b9e94229d6023e9e266e9ecfa0cb1ab5aa80#diff-35759cbb09e13d5ecf49512930911bb6. *thanks radekg*
*   writenig provider for sakuracloud ,wip. *thanks sawanoboly*
*   follow new require style. *thanks sawanoboly*
*   Follow message -> DEPRECATION Fog::XML::Connection is deprecated use Fog::Core::Connection instead. *thanks sawanoboly*
*   Fix wrong aliases at Fog::Volume::SakuraCloud::Archive. *thanks sawanoboly*
*   enhanced attributes for sakuracloud volume archive. *thanks sawanoboly*
*   use snake case for size_mb. *thanks sawanoboly*

#### [openstack]
*   add unit test covering server.floating_ip_addresses. *thanks Erik Mackdanz*
*   Add more observable states for openstack models. *thanks radekg*
*   Add more observable states for openstack models - tests added. *thanks radekg*
*   Add more observable states for openstack models - tests corrected. *thanks radekg*
*   image.update_image_members expects are incorrect #2627. *thanks radekg*
*   Fix for OpenStack flavor id calculation. *thanks radekg*

#### [openstack|storage]
*   Fix extracted request. *thanks Paul Thornthwaite*

#### [ovirt]
*   add support for ca cert. *thanks Amos Benari*
*   fixed interfaces and volume list.     The return list is now always fog object and not rbovirt objects. *thanks Amos Benari*

#### [rackspace|compute_v2]
*   adds virtual interfaces support. *thanks Kyle Rames*
*   removing hard coded timeout in servers. *thanks Kyle Rames*

#### [vcloud]
*   Remove helpless helper. *thanks Paul Thornthwaite*

#### [vcloud_director]
*   get_network_complete. *thanks Mike Pountney*
*   Add tests and connect up get_network_complete. *thanks Mike Pountney*
*   fix typo as per #2621. *thanks Mike Pountney*

#### [vsphere]
*   fix broken detection of existing network interface type. *thanks Martin Matuska*

#### [vsphere|compute]
*   Expose template names and UUIDs. *thanks Dominic Cleal*


## 1.20.0 02/07/2014
*Hash* 76846bb4bd2d94ec169757f6f4125dc173359140

Statistic     | Value
------------- | --------:
Collaborators | 54
Downloads     | 4366478
Forks         | 1074
Open Issues   | 166
Watchers      | 2904

**MVP!** Ash Wilson

#### [AWS|EC2]
*   request_spot_instances.rb requires that date parameters be iso8601. *thanks Frederick Cheung*
*   fix sporadically failing network_acl_tests.rb. *thanks Frederick Cheung*

#### [Brightbox]
*   Sort schema collections. *thanks Paul Thornthwaite*
*   Add CloudIp#destination_id. *thanks Paul Thornthwaite*
*   Add support for Cloud SQL service. *thanks Paul Thornthwaite*
*   Remove old #destroy request. *thanks Paul Thornthwaite*

#### [OpenStack|Network]
*   Add CRUD for SecurityGroup and SecurityGroupRules. *thanks Brandon Dunne*
*   Display subnets as a child of Network. *thanks Brandon Dunne*
*   Add security_groups and security_group_rules hashes to the base Mock data. *thanks Brandon Dunne*
*   Add tests for security_groups and security_group_rules methods. *thanks Brandon Dunne*

#### [aws]
*   align hashrockets, remove whitespace. *thanks Eric Stonfer*
*   mock block device mapping on run_instances. *thanks Josh Lane*
*   mock setup block device deleteOnTermination. *thanks Josh Lane*

#### [aws|elb]
*   Mimic create_load_balancer mock. *thanks Jose Luis Salas*
*   compact possible nil. *thanks geemus*

#### [aws|fog]
*   Don't pass :host to Excon request. *thanks Jason Smith*

#### [aws|iam]
*   Mock delete_server_certificate raises NotFound appropriately. *thanks Dan Peterson*
*   UploadServerCertificate parser respects CertificateBody and CertificateChain. *thanks Dan Peterson*

#### [core]
*   Adds `ssh_ip_address=` so users can override the ssh address per issue #2584. *thanks Kyle Rames*
*   updating Server models to use ssh_ip_address rather than public_ip_address. *thanks Kyle Rames*
*   updating ssh_ip_address to take a block in order to defer address specification to execution time. *thanks Kyle Rames*

#### [digital ocean|compute]
*   pass '1' instead of true for scrub. *thanks geemus*

#### [digitalocean|compute]
*   add created_at timestamp as attribute of server. *thanks Dave Donahue*
*   additional test coverage and some maintenance. *thanks Dave Donahue*
*   allow bootstrapping with keys rather than paths. *thanks Dave Donahue*
*   sync with latest master for new fog_test_server_attributes. *thanks Dave Donahue*
*   fix merge conflict in fog_test_server_attributes. *thanks Dave Donahue*

#### [google]
*   Handle 500 errors from GCE. *thanks Carlos Sanchez*
*   Excon::Errors::NotFound never reaches the models. *thanks Carlos Sanchez*
*   Disk.ready? should not reload the data. *thanks Carlos Sanchez*
*   Expose Google API client, compute and api_url for easier debugging. *thanks Carlos Sanchez*

#### [google|compute]
*   Readme update. *thanks Nat Welch*
*   Remove RHEL from Global Project list. *thanks Nat Welch*

#### [hp|compute_v2]
*   added security group support. *thanks Kyle Rames*

#### [libvirt]
*   fix readme gem reference. *thanks geemus*

#### [libvirt|compute]
*   Allow volumes to have backing volumes. *thanks Dominic Cleal*

#### [misc]
*   Use endpoint, port, and path_style options in AWS storage Mock. *thanks Adam Stegman and Zach Robinson*
*   Added Openstack compute support for add_security_group and remove_security_group. *thanks Adan Saenz*
*   Fixed method names for Mock objects for add/remove_security_group. *thanks Adan Saenz*
*   Add support for AWS VPC Network ACLs. *thanks Alex Coomans*
*   Fix subnet mocking, related to #2510. *thanks Alex Coomans*
*   Fix DhcpOption#associate. *thanks Alex Coomans*
*   reject unnecessary methods creation and clean up remove_method. *thanks Alexander Lomov*
*   make test output more verbose if provider service is unavailable. *thanks Alexander Lomov*
*   mock tests doesn't have to rely on provider availability. *thanks Alexander Lomov*
*   fix get_bucket_acl request method in Google Cloud Storage. *thanks Alexander Lomov*
*   fix put_bucket_acl request for Google Cloud Storage service. *thanks Alexander Lomov*
*   remove unnecessary duplication in put_bucket_acl request in Google storage. *thanks Alexander Lomov*
*   add put_object_acl request to Google Cloud Storage service. *thanks Alexander Lomov*
*   Removed host from SQS connection request arguments. *thanks Amy Sutedja*
*   Revert "[aws|sqs] remove host/port from request". *thanks Amy Sutedja*
*   Create a realistic, but fake, service catalog. *thanks Ash Wilson*
*   The fake service catalog matches format. *thanks Ash Wilson*
*   DRY up some of that service catalog generation. *thanks Ash Wilson*
*   Handle failed logins. *thanks Ash Wilson*
*   Rackspace identity_tests now pass in mocking mode. *thanks Ash Wilson*
*   Mock the #get_containers Storage call. *thanks Ash Wilson*
*   Mock the #head_container Storage call. *thanks Ash Wilson*
*   Mock the #put_container Storage request. *thanks Ash Wilson*
*   Don't count the :meta entry as an object. *thanks Ash Wilson*
*   Another pair of tests that already work with mocks. *thanks Ash Wilson*
*   Some speculative mocking of #get_container. *thanks Ash Wilson*
*   Refactor to use some utility classes. *thanks Ash Wilson*
*   Already took care of these three. *thanks Ash Wilson*
*   Don't call methods on a non-enabled CDN. *thanks Ash Wilson*
*   Mock delete_object and put_object. *thanks Ash Wilson*
*   Mock get_object. *thanks Ash Wilson*
*   Mock HEAD request for objects. *thanks Ash Wilson*
*   Refactor into Fog::Storage::Rackspace::Common. *thanks Ash Wilson*
*   Support "chunking" in #put_object. *thanks Ash Wilson*
*   Implement bulk deletion. *thanks Ash Wilson*
*   Test failure cases for mocks, too. *thanks Ash Wilson*
*   Mock #post_set_meta_temp_url_key with a no-op. *thanks Ash Wilson*
*   Eliminate a ton of redundancy. *thanks Ash Wilson*
*   Large object tests now pass in mock mode. *thanks Ash Wilson*
*   Account tests now pass. *thanks Ash Wilson*
*   directories_tests now pass with mocks. *thanks Ash Wilson*
*   First half of directory_tests now pass. *thanks Ash Wilson*
*   The rest of the directory_tests now pass too. *thanks Ash Wilson*
*   file_tests now all pass under mocking. *thanks Ash Wilson*
*   files_tests already works with the mocks. Huzzah!. *thanks Ash Wilson*
*   storage_tests now all pass under mocking, too. *thanks Ash Wilson*
*   Refactoring: #each_part in MockObject. *thanks Ash Wilson*
*   Documentation for the storage mock utility classes. *thanks Ash Wilson*
*   Split a multiline statement with trailing .'s. *thanks Ash Wilson*
*   Parenthesize method parameters. *thanks Ash Wilson*
*   Create the mock Queues service. *thanks Ash Wilson*
*   Enable Queues service tests for mocking. *thanks Ash Wilson*
*   Enable Cloud Queues request tests. *thanks Ash Wilson*
*   Mock the create_queue call. *thanks Ash Wilson*
*   Mock the list_queues call. *thanks Ash Wilson*
*   Mock the delete_queue call. *thanks Ash Wilson*
*   Mock the get_queue call. *thanks Ash Wilson*
*   No need to map! here, we're modifying the hashes. *thanks Ash Wilson*
*   Mock the queue_stats request. *thanks Ash Wilson*
*   Handle a corner case in the create_queue mock. *thanks Ash Wilson*
*   On to the messages_tests. *thanks Ash Wilson*
*   Mock the create_message call. *thanks Ash Wilson*
*   get_message and list_messages mocks. *thanks Ash Wilson*
*   Initial support for mocking delete_message. *thanks Ash Wilson*
*   Enable claim_tests in mocking mode. *thanks Ash Wilson*
*   Mock the create_claim request. *thanks Ash Wilson*
*   create_claim returns a 204 for empty claims. *thanks Ash Wilson*
*   Mock the get_claim request. *thanks Ash Wilson*
*   Mock the update_claim request. *thanks Ash Wilson*
*   Mock the delete_claim request. *thanks Ash Wilson*
*   Refactor out some common error checking. *thanks Ash Wilson*
*   Actually compute #claimed and #free. *thanks Ash Wilson*
*   Similar refactoring for accessing MockClaims. *thanks Ash Wilson*
*   Some documentation. *thanks Ash Wilson*
*   Completely untested ageoff code. *thanks Ash Wilson*
*   Enable model tests for Claims. *thanks Ash Wilson*
*   Enable the claims_tests in mocking mode. *thanks Ash Wilson*
*   Enable the message_tests in mocking mode. *thanks Ash Wilson*
*   Enable the messages_tests in mocking mode. *thanks Ash Wilson*
*   Enable the queue_tests in mocking mode. *thanks Ash Wilson*
*   Er, *actually* enable the messages_tests for mocks. *thanks Ash Wilson*
*   Enable the queues_tests in mocking mode. *thanks Ash Wilson*
*   Refactor PATH_BASE into a constant. *thanks Ash Wilson*
*   Er, actually enable queues_tests, too. *thanks Ash Wilson*
*   Yep, just did that. *thanks Ash Wilson*
*   Make the delete_message mock consistent. *thanks Ash Wilson*
*   Only extend the TTL of a MockMessage. *thanks Ash Wilson*
*   Don't use `&:to_h` style enumerations. *thanks Ash Wilson*
*   I guess there isn't really a better place. *thanks Ash Wilson*
*   Include the oldest and newest message in stats. *thanks Ash Wilson*
*   Missed a chance to use queue.claim!. *thanks Ash Wilson*
*   Replace the JSON round-trip with #stringify. *thanks Ash Wilson*
*   A hack to fix the Claim#messages= hack on 1.8.7. *thanks Ash Wilson*
*   Use case-insensitive header access for Location. *thanks Ash Wilson*
*   Fix case sensitivity of the Content-type header. *thanks Ash Wilson*
*   extended IOPS support. *thanks Ben Chadwick*
*   add Iops to snapshot model. *thanks Ben Chadwick*
*   adding new HVM-based instance types to AWS in lib/fog/aws/models/compute/flavors.rb. *thanks Ben Hundley*
*   White space cleanup. *thanks Brandon Dunne*
*   use current region for subnet checks when creating DB and Cache subnet groups. *thanks Brian Nelson*
*   add aws storage multipart upload mocks. *thanks Brian Palmer*
*   enable the relevant tests for multipart mocks. *thanks Brian Palmer*
*   Write logger output to stderr to conform to convention. *thanks Bruno Enten*
*   [google][compute] Update to API v1. *thanks Carlos Sanchez*
*   Update rubygems to fix travis in ruby 1.8. *thanks Carlos Sanchez*
*   Fix typos that make ruby 1.8 break. *thanks Carlos Sanchez*
*   Changed openstack server model to build security group objects without generating deprication warning messages. *thanks Chris Howe*
*   [google][compute] Add support for blank disks (i.e. remove code that required only image or snapshot based disks to be created). *thanks Doug Henderson*
*   Fixes for AWS Mocking. *thanks Doug Henderson*
*   Implemented Replace Route. *thanks Eric Herot*
*   Add replace_route failure tests. *thanks Eric Herot*
*   Undo date change. *thanks Eric Herot*
*   Add a test for passing a nonexisiting route table and an exisiting internet gateway to replace_route failures section. *thanks Eric Herot*
*   Switch to hashed parameters method for handling replace_route arguments. *thanks Eric Herot*
*   Remove commented code. *thanks Eric Herot*
*   making destination_cidr_block a required parameter for replace_route. *thanks Eric Herot*
*   Switch to or-equals for DestinationCidrBlock and instanceOwnerId. *thanks Eric Herot*
*   Moved #compact to a sesparate line to make it a little more obvious. *thanks Evan Light*
*   Servers with a password locked root user have a nil `@password.` *thanks Evan Light*
*   Issues a deprecation warning if the Rackspace Fog user is relying on region to be provided by default. *thanks Evan Light*
*   Closes #2469. *thanks Evan Light*
*   Ported fog rackspace storage docs for OpenStack. *thanks Evan Light*
*   Oops. Missed a couple of deletions of CDN stuff. *thanks Evan Light*
*   No, we don't want people hitting up Rackspace specifically about OpenStack docs. It's a joint effort!. *thanks Evan Light*
*   Adds getting started guide for OpenStack fog. *thanks Evan Light*
*   Added Ruby-specific code blocks. *thanks Evan Light*
*   Formating fixes. *thanks Evan Light*
*   Fixed another formating error. *thanks Evan Light*
*   Fixes #2586. *thanks Evan Light*
*   Check if security group is nil, fixes #2507. *thanks Gaurish Sharma*
*   Update Flavours.rb with new M3 Instance Types. *thanks Gaurish Sharma*
*   Fixing defect with handling of multiple <item> elements in reponse to describe-reservations. *thanks Joe Kinsella*
*   Fix typo puplic -> public. *thanks John F. Douthat*
*   Tests and fixes for Elasticache VPC subnet groups. *thanks Jon Topper*
*   Rackspace/examples; cloudfiles directory is set to public, therefore file is accessible. *thanks Jonathon Scanes*
*   DNSimple get_domain also accepts domain name. *thanks Jose Luis Salas*
*   rm rspec dependency. *thanks Joseph Anthony Pasquale Holsten*
*   adding Rage4 module file. *thanks Joshua Gross*
*   all request types support by the rage4 api without mocks or tests. *thanks Joshua Gross*
*   setting up testing library to start writing tests. *thanks Joshua Gross*
*   Wrote shindo tests for all supported requests.  Resulted in a lot of debuggin of     request methods.  As well update zone/record models to work in simple cases. *thanks Joshua Gross*
*   using proper hash syntax for ruby 1.8.7. *thanks Joshua Gross*
*   when a zone doesn't exist return nil for rage4. *thanks Joshua Gross*
*   previous change was for records, duplicating nil return for zones now. *thanks Joshua Gross*
*   changing handling of zone returns after testing that data was different on errors and success. *thanks Joshua Gross*
*   adding domain alias to record to match zerigo api in rage4. *thanks Joshua Gross*
*   quick syntax fix for an attribute alias. *thanks Joshua Gross*
*   making a reader for domain to duplicate name attribute. *thanks Joshua Gross*
*   adding more attributes to rage4 records. *thanks Joshua Gross*
*   updating documentation for list records in rage4. *thanks Joshua Gross*
*   fixing a typo in rage4 record. *thanks Joshua Gross*
*   minor fixes for record and domain destroying. *thanks Joshua Gross*
*   fixing rage4 structure as to recent fog chagnes. *thanks Joshua Gross*
*   fixing service creation in rage4. *thanks Joshua Gross*
*   Pass params necessary to upload key pairs. *thanks Joshua Schairbaum*
*   Fix logic bug in data structure creation. *thanks Joshua Schairbaum*
*   Revert "[hp|compute_v2] added security group support". *thanks Kyle Rames*
*   normalize requires syntax. *thanks Lance Ivy*
*   ensure that each service requires its provider. *thanks Lance Ivy*
*   openstack orchestration no longer depends on cloud formation. *thanks Lance Ivy*
*   ensure that all services require their provider. *thanks Lance Ivy*
*   create core for each provider. keep load hook for provider. *thanks Lance Ivy*
*   extend load time benchmarks for new load targets. *thanks Lance Ivy*
*   don't require service when registering it. *thanks Lance Ivy*
*   add benchmark scripts to load each provider and service independently. *thanks Lance Ivy*
*   support rackspace storage delete_at and delete_after headers. *thanks Marshall Yount*
*   fixed misspelling. *thanks Matheus Mina*
*   refactor DataPipeline format conversion, allowing for arrays of refs. *thanks Matt Gillooly*
*   make disassociate_address mock idempotent, by not requiring instance data. *thanks Michael Hale*
*   ignore more Ruby version manager files. *thanks Mike Fiedler*
*   drop dependency on deprecated ruby-hmac gem, fixes #2034. *thanks Mike Fiedler*
*   Always scrub data when deleting a server from DO. *thanks Nat Welch*
*   Hardcode some responses to tests. *thanks Nat Welch*
*   Cleanup some whitespace in the Google dir. *thanks Nat Welch*
*   fix error - invalid excon request keys: :host. *thanks Nathan Williams*
*   Make Coveralls opt-in. *thanks Paul Thornthwaite*
*   Reduce size of Travis matrix. *thanks Paul Thornthwaite*
*   Revert to original .travis.yml and include one case. *thanks Paul Thornthwaite*
*   Record and Zone put requests are idempotent. *thanks Peter Drake*
*   Add Ruby 2.1.0 to the test matrix. *thanks Peter M. Goldstein*
*   Fixed error when accessing files via atmos where keys contain spaces. *thanks Peter Vawser*
*   There is a bug here or maybe i'm using the gem wrong...     Edit     you should merge the ACLs after merging the meta_has if not The new permission will be overwritten by the old one.     If Before you had a directory with :     X-Container-Read: .r:*,.rlistings. *thanks Piotr Kedziora*
*   Add support for Rackspace's Extract Archive API call     See http://docs.rackspace.com/files/api/v1/cf-devguide/content/Extract_Archive-d1e2338.html     for documentation on the API call. *thanks Sammy Larbi*
*   Set the Content-Type of extract_archive requests to ''     The documentation for extract archive (http://docs.rackspace.com/files/api/v1/cf-devguide/content/Extract_Archive-d1e2338.html) says if a Content-Type is sent, every object in the archive will have its Content-Type set to that value. However, if a blank Content-Type is sent, CloudFiles will determine it based on each individual file. Since we don't want every file to be interpreted as an archive (which would happen if we let Fog determine the Content-Type), we set it explicitly to a blank string. *thanks Sammy Larbi*
*   Use @ in comment for YARD docs. *thanks Sammy Larbi*
*   Update Nokogiri version. *thanks Sascha Korth*
*   Fix version. *thanks Sascha Korth*
*   Undo last nokogiri version setting. *thanks Sascha Korth*
*   Remove duplicates. *thanks Sean Handley*
*   Formatting flavor data and updating documentation to include i2 instances. *thanks Shaun Davis*
*   Renaming ebs_optimized -> ebs_optimized_available. *thanks Shaun Davis*
*   Removing unnecessary comments. *thanks Shaun Davis*
*   Display number of instance store volumes per instance flavor. *thanks Shaun Davis*
*   Switch to DNSimple versioned API. *thanks Simone Carletti*
*   Cleanup documentation and resource representations. *thanks Simone Carletti*
*   Remove :host key in SQS request method to eliminate excon error. *thanks Steve Meyfroidt*
*   get non capitalized content-type. *thanks bugagazavr*
*   fix MVP exclude list. *thanks geemus*
*   add CONTRIBUTORS, assign copyright. *thanks geemus*
*   fix link in license. *thanks geemus*
*   update contributors/license files. *thanks geemus*
*   Update network parser to add private ips to array     Previously the network parser would overwrite the private ip addresses     if there were more than one. These are now added to an array. *thanks joe*
*   Update documentation of return values. *thanks joe*
*   [google][compute] Add rhel-cloud to project search list. *thanks kbockmanrs*
*   Implement Rackspace Monitoring Agent Host information. *thanks kfafel*
*   minor fix for get_filesystems_info. *thanks kfafel*
*   fix mock output hash. *thanks kfafel*
*   tighten up agent info mocks. *thanks kfafel*
*   Implement agent_info tests; better mocks. *thanks kfafel*
*   Cleaned up agent_tests. *thanks kfafel*
*   add missing get_agent and list_agents. *thanks kfafel*
*   addresses and settags. *thanks neillturner*
*   delete snapshots and address requests for google. *thanks unknown*
*   fix a couple of bugs. *thanks unknown*
*   add attach and detach disk. *thanks unknown*

#### [openstack]
*   image.update_image_members expects are incorrect #2627. *thanks radekg*
*   Fix for OpenStack flavor id calculation. *thanks radekg*

#### [openstack|compute]
*   Allow to use Symbol when specifying the hash of NICs. *thanks KATOH Yasufumi*
*   Adding docs for OpenStack Compute. *thanks Kyle Rames*

#### [rackspace|compute]
*   updating Rackspace compute docs. *thanks Kyle Rames*

#### [rackspace|compute_v2]
*   updates key_pair model to pass additional attributes onto compute service. (You can now pass public and private keys via the model). *thanks Kyle Rames*
*   added key_name and modified key_pair= to take KeyPair objects as well as strings in order to be more compatible with other fog providers. *thanks Kyle Rames*

#### [storm_on_demand]
*   don't pass host to request. *thanks Josh Blancett*

#### [vcloud_director]
*   fix typo as per #2621. *thanks Mike Pountney*


## 1.19.0 12/19/2013
*Hash* 15180fd7c0993f7fe6cfdc861a4db7ada14825ad

Statistic     | Value
------------- | --------:
Collaborators | 53
Downloads     | 3970307
Forks         | 1015
Open Issues   | 149
Watchers      | 2831

**MVP!** Mike Pountney

#### [AWS]
*   add modify_vpc_attribute. *thanks Eric Stonfer*
*   add modify_vpc_attribute. *thanks Eric Stonfer*

#### [AWS|Autoscaling]
*   Fix option name in documentation. *thanks Frederick Cheung*

#### [AWS|RDS]
*   Support for creating and removing subnet groups. *thanks Akshay Joshi*

#### [AWS|Storage]
*   fixed signed urls when using session tokens. *thanks Frederick Cheung*

#### [Brightbox]
*   Fix test issue with reusing servers. *thanks Paul Thornthwaite*
*   Add new SSL cert metadata attributes. *thanks Paul Thornthwaite*
*   Remove commented resource from schema. *thanks Paul Thornthwaite*
*   Fix typo in yard tag. *thanks Paul Thornthwaite*
*   Clean up Cloud IP mapping code. *thanks Paul Thornthwaite*
*   Code style clean up. *thanks Paul Thornthwaite*

#### [OS|Volume]
*   Add listing/showing volume types. *thanks Grzesiek Kolodziejczyk*

#### [aws]
*   Implement missing mocks for Route 53. *thanks Carlos Sanchez*
*   style fix for address model. *thanks Eric Stonfer*
*   narrow scope of unf warning. *thanks geemus*

#### [aws:storage]
*   path_style option availability. *thanks David Illsley*

#### [aws|cloudwatch]
*   remove :host key from request. *thanks Brian D. Burns*

#### [aws|dns]
*   Don't set mock changes to INSYNC immediately, only after some timeout. *thanks Carlos Sanchez*

#### [aws|elb]
*   support for cross zone load balancing. *thanks Frederick Cheung*

#### [aws|rds]
*   Implement `ready?` for subnet group. *thanks Akshay Joshi*
*   Support Iops parameter. *thanks Eric Hankins*

#### [aws|sqs]
*   remove host/port from request. *thanks geemus*

#### [aws|storage]
*   warn/load unf as needed. *thanks geemus*

#### [bluebox]
*   remove :host from excon request. *thanks Sam Cooper*

#### [core]
*   use Excon :persistent option. *thanks Brian D. Burns*

#### [digitalocean]
*   Add support for private networking. *thanks Trae Robrock*

#### [dnsimple]
*   remove host from request. *thanks Jose Luis Salas*

#### [general]
*   Allow default wait_for interval to be overiden globally. *thanks radekg*
*   Merge Forg.interval and Fog.timeout into a single file. *thanks radekg*

#### [google]
*   natIP is set to true when it must be an ip. *thanks Carlos Sanchez*
*   Add support for instance tags. *thanks Carlos Sanchez*
*   Add support for instance tags. *thanks Carlos Sanchez*
*   Raise Fog::Errors::NotFound on 404. *thanks Carlos Sanchez*
*   Implement disk mocks and enable tests. *thanks Carlos Sanchez*
*   Alias flavor_id and machine_type for consistency with other providers. *thanks Carlos Sanchez*
*   Instances are created without description, and disk size is ignored. *thanks Carlos Sanchez*
*   Implement operation model. *thanks Carlos Sanchez*

#### [hp]
*   Add documentation and examples for the provider for HP Cloud Services. *thanks Rupak Ganguly*
*   Fix links in some documentation pages. *thanks Rupak Ganguly*
*   Fix a few more documentation page links. *thanks Rupak Ganguly*
*   Fix connection section for newer services. *thanks Rupak Ganguly*

#### [misc]
*   Get VcloudDirector working again in fog interactive. Fixes #2373. *thanks Adam Heinz*
*   Use OpenSSL::Digest instead of deprecated OpenSSL::Digest::Digest. *thanks Akira Matsuda*
*   Add new AWS EC2 flavors to the compute model. *thanks Alfred Moreno*
*   Add exponential backoff to backoff_if_unfound. *thanks Andrew Leonard*
*   add in 'AssociatePublicIpAddress' to launch configuration creation. *thanks Andrew Stangl*
*   merge upstream changes and resolve merge conflict. *thanks Andrew Stangl*
*   add in 'AssociatePublicIpAddress' to launch configuration creation. *thanks Andrew Stangl*
*   remove duplicate code introduced during rebase. *thanks Andrew Stangl*
*   tidy up and remove whitespace. *thanks Andrew Stangl*
*   use original error message if none given. *thanks Brian D. Burns*
*   use Fog::JSON. *thanks Brian D. Burns*
*   Add ready? method to aws VPC and Subnet models. *thanks Brian Nelson*
*   Add pending -> available transitions for AWS VPC and Subnets. *thanks Brian Nelson*
*   all? not working in JRuby 1.7.5+. Configure Travis. *thanks Carlos Sanchez*
*   Disable specific tests that don't pass on jruby 1.7.5+. *thanks Carlos Sanchez*
*   Disable coveralls on travis with jruby. *thanks Carlos Sanchez*
*   Ensure vpc created in a test doesn't affect another. *thanks Carlos Sanchez*
*   Allows custom username for aws spot instances. *thanks Casey Abernathy*
*   Added content_encoding attribute to Rackspace storage. *thanks Cezar Sa Espinola*
*   Remove :host key in RDS request method to eliminate excon warning. *thanks David Faber*
*   Remove stray private key. *thanks Dominic Cleal*
*   Update excon dependency to version ~>0.30.0. *thanks Erik Michaels-Ober*
*   Fix typo in documentation. *thanks Erik Michaels-Ober*
*   ecloud api version bump. *thanks Eugene Howe*
*   Lock user by default. *thanks Evan Light*
*   Updated docs to reflect RackConnect compatibility. *thanks Evan Light*
*   Typo. *thanks Evan Light*
*   service attribute conflicts with the service defined in the parent. *thanks Evan Petrie*
*   details sometimes fails with a not-found. *thanks Evan Petrie*
*   Add index for describe_images parameters that use them. *thanks James Bence*
*   Make changes to a copy of the options parameter. *thanks Joe Yates*
*   Give 'versionId' value the expected structure. *thanks Joe Yates*
*   Add IAMInstanceProfile support to launch configs. *thanks Jon Topper*
*   Improve support for VPC Security Groups in RDS. *thanks Jon Topper*
*   Add IAMInstanceProfile support to launch configs. *thanks Jon Topper*
*   Improve support for VPC Security Groups in RDS. *thanks Jon Topper*
*   Remove duplication. *thanks Jon Topper*
*   Update S3 ACL whitelist. *thanks Keith Barrette*
*   Revert "[rackspace] wrapping test blocks around test helpers to prevent unexpected shindo exceptions". *thanks Kyle Rames*
*   merging in changes. *thanks Kyle Rames*
*   Added syntax highlighting for ruby code fragments. *thanks Mark IJbema*
*   Add request to set VM annotations in vSphere. *thanks Martin Matuska*
*   Add the uncommitted property to the vsphere datastore object. *thanks Martin Matuska*
*   changed shutdown to reboot in reboot server method. *thanks Matheus Mina*
*   changed __consoles to consoles and renamed consoles method to get_consoles. *thanks Matheus Mina*
*   fixed tests. *thanks Matheus Mina*
*   fixed consoles to use :aliases. *thanks Matheus Mina*
*   fixed AWS::Glacier::Vault.delete_notification_configuration so that it passes the ID to the underlying core request. *thanks Matt Pokress*
*   Allow custom Mock.not_implemented message. *thanks Mike Pountney*
*   Allow custom Mock.not_implemented message. *thanks Mike Pountney*
*   ignore .ruby-version. *thanks Mike Pountney*
*   vApp rename via put_vapp_name_and_description. *thanks Mike Pountney*
*   use std options={} format for optional parameters. *thanks Mike Pountney*
*   Find all and by-name Mock for Query API orgVdcNetwork. *thanks Mike Pountney*
*   improve network mock test data, to include vdc & IsShared. *thanks Mike Pountney*
*   fix tests for running against live environment. *thanks Mike Pountney*
*   make Mock vcloud_director_host an FQDN. *thanks Mike Pountney*
*   rename Mock vcloud_director_host to pass URI.parse. *thanks Mike Pountney*
*   Add delete_network request. *thanks Mike Pountney*
*   add Mock for post_create_network, use this to create/delete network in tests. *thanks Mike Pountney*
*   Modified AWS S3 mock, so that it errors when creating an existing bucket. *thanks Nassos Antoniou*
*   return NS and SOA records as per https://github.com/fog/fog/issues/2419 - this allows us to work with NS subdelegations, as well as the NS and SOA records while the type can't be changed, the values and TTLs can be. *thanks Nathan Sullivan*
*   Added parameter to force request timeout on xen. *thanks Paulo Henrique Lopes Ribeiro*
*   Adding more XenServer models. *thanks Paulo Henrique Lopes Ribeiro*
*   Forget to reference models on main class. *thanks Paulo Henrique Lopes Ribeiro*
*   adding spot price to launch configurations. *thanks Rodrigo Estebanez*
*   Sometimes :Environments is not a key. *thanks Sarah Vessels*
*   Fog::Storage::Local#directories#all: Don't break when :local_root folder is missing. *thanks Sjoerd Andringa*
*   Also call #load in case of missing local root folder. *thanks Sjoerd Andringa*
*   using new way of task mocking for edgegateway tests. *thanks Sneha Somwanshi*
*   updated documentation for put_vm. *thanks Sneha Somwanshi*
*   openstack modifications. *thanks Thom Mahoney & Eugene Howe*
*   openstack modifications. *thanks Thom Mahoney & Eugene Howe*
*   Need to list block in the argument list to access the variable. *thanks Trae Robrock*
*   Update describe_addresses.rb. *thanks Virender Khatri*
*   Update address.rb. *thanks Virender Khatri*
*   add gittip shield. *thanks geemus*
*   fix for broken AWS records tests. *thanks geemus*
*   expanding/rewriting the getting-help/involved section of README. *thanks geemus*
*   fix spacing for getting help section of README. *thanks geemus*
*   streamline openstack security groups tests. *thanks geemus*
*   move license to LICENSE.md. *thanks geemus*
*   add CONTRIBUTING.md. *thanks geemus*
*   just refer to contrib/license in readme to DRY. *thanks geemus*
*   Create parser for AWS assign private ip addresses. *thanks joe*
*   Assign private ip parser. *thanks joe*
*   add assign private ip request path. *thanks joe*
*   fix typo and add mock. *thanks joe*
*   Update error message on tests. *thanks joe*
*   private ip tests. *thanks joe*
*   pass options as a hash add support for multiple ips. *thanks joe*
*   update tests to reflect argument hash. *thanks joe*
*   remove debugging. *thanks joe*
*   fix variable name typo. *thanks joe*
*   remove unneeded test and destroy objects. *thanks joe*

#### [openstack|compute]
*   Basic examples for Compute. *thanks Daniel Lobato*

#### [openstack|storage]
*   adding missing request methods to Storage service. *thanks Kyle Rames*
*   updating request to use the proper file structure. *thanks Kyle Rames*

#### [rackspace]
*   updating compute and storage to pull service net urls from service catalog. *thanks Kyle Rames*
*   wrapping test blocks around test helpers to prevent unexpected shindo exceptions. *thanks Kyle Rames*
*   updating test helper to log errors and not throw exceptions to prevent shindo from halting if an error occurs. *thanks Kyle Rames*
*   fixing more live tests. *thanks Kyle Rames*
*   fixing broken tests caused by bad helper. *thanks Kyle Rames*
*   apply documentation edits. *thanks Kyle Rames*
*   apply documentation edits. *thanks Kyle Rames*

#### [rackspace|compute]
*   compute_v2 should require fog/rackspace. *thanks Brian D. Burns*

#### [rackspace|identity]
*   re-implementing service catalog in hopes of providing a faster more flexible solution. *thanks Kyle Rames*
*   updated service catalog support service net. *thanks Kyle Rames*
*   updated service catalog to return global endpoint if specified region endpoint does not exist. *thanks Kyle Rames*
*   tweaking service catalog to support ruby 1.8.7. *thanks Kyle Rames*

#### [rackspace|queues]
*   adding examples create queue, delete queue, and post message. *thanks Kyle Rames*
*   adding id alias for identity; fixed bug in message#identity that returned the id along with the claim_id query string; removed redundant code. *thanks Kyle Rames*
*   adding more examples. *thanks Kyle Rames*
*   fixing examples. *thanks Kyle Rames*
*   adding request YARD docs. *thanks Kyle Rames*
*   adding YARD docs. *thanks Kyle Rames*
*   adding the queues getting started guide. *thanks Kyle Rames*
*   updating set_messages= to populate the claim_id attribute on messages in order for destroy to work properly. *thanks Kyle Rames*
*   adding the queues getting started guide. *thanks Kyle Rames*

#### [vSphere]
*   Implementation of feature to specify scsi_controller type at create type and also support the attribute scsi_controller to return the right class. *thanks Marc Grimme*

#### [vcloud_director]
*   fix models vms_test so is pending on empty environment. *thanks Dan Abel*
*   tests become pending not failing on absense of testable resources. *thanks Dan Abel*
*   post_create_org_vdc_network. *thanks Mike Pountney*
*   fix to input format for post_create_org_vdc_network. *thanks Mike Pountney*
*   fix query test to handle delete_network. *thanks Mike Pountney*
*   Fix medias#create - issue #2440. *thanks Nick Osborn*
*   s/`@end_point/end_point/.` *thanks Nick Osborn*
*   update name, description and storage_profile for vm. *thanks Sneha Somwanshi*
*   ensure that MetadataEntry is a list. *thanks Sneha Somwanshi*
*   Show guest customization "admin password auto". *thanks Stefano Tortarolo*
*   Handle Guest admin password. *thanks Stefano Tortarolo*
*   allow nullable for gateway in network tests. *thanks geemus*

#### [vclouddirector]
*   Shore up tests re EdgeGateway. *thanks Mike Pountney*
*   correct put_vapp_name_and_description documentation. *thanks Mike Pountney*

#### [vsphere|compute]
*   restore default guest_id so setting it is optional. *thanks Dominic Cleal*
*   Force shutdown a server if VMware Tools is installed, but isn't running. *thanks Kevin Menard*
*   Pass server shutdown options through to the stop operation so the caller can force shutdown if desired. *thanks Kevin Menard*
*   get_vm_interface returns a hash, not an object that responds to :key. *thanks Kevin Menard*
*   Renamed 'vm' to 'server' to be more in line with other fog providers. *thanks Kevin Menard*
*   Backed out the changed to use a hash and fixed the conversion to an Interface class. *thanks Kevin Menard*
*   Implemented idiomatic interface destruction. *thanks Kevin Menard*
*   Default to a VirtualE1000 NIC if not configured. *thanks Kevin Menard*
*   Implemented idiomatic interface creation. *thanks Kevin Menard*
*   interfaces#get now properly initializes the Interface object. *thanks Kevin Menard*
*   Deprecated the old interface creation and destruction methods now that the idiomatic ones exist. *thanks Kevin Menard*

#### [xenserver]
*   Updated models to have all attributes from version 6.2.0. *thanks Paulo Henrique Lopes Ribeiro*
*   Adding more XenServer Models. *thanks Paulo Henrique Lopes Ribeiro*


## 1.18.0 10/31/2013
*Hash* 5442bc7e893eb73dae8bb5ee8ef0845c78c43627

Statistic     | Value
------------- | --------:
Collaborators | 53
Downloads     | 3557402
Forks         | 967
Open Issues   | 171
Watchers      | 2767

**MVP!** Mike Hagedorn

#### [aws|compute]
*   mock instance tenancy on servers. *thanks Eugene Howe*
*   Fixed a typo. *thanks Kevin Menard*

#### [aws|data_pipeline]
*   don't pass host to request. *thanks Matt Gillooly*

#### [ecloud|compute]
*   Replace /cloudapi/ecloud with a configurable path. *thanks Todd Willey*

#### [hp]
*   Add a simple http instrumentor. *thanks Rupak Ganguly*
*   Fix a small issue with the simple instrumentor. Remove igonore_aweful_caching from compute provider. *thanks Rupak Ganguly*
*   Another fix to the simple instrumentor. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Add a simple http instrumentor. *thanks Rupak Ganguly*
*   Fix a small issue with the simple instrumentor. Remove igonore_aweful_caching from compute provider. *thanks Rupak Ganguly*
*   Another fix to the simple instrumentor. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*

#### [hp|block_storage_v2]
*   Add a new Block Storage V2 provider for next gen block storage services. *thanks Rupak Ganguly*
*   Add request methods for volumes, along with tests. *thanks Rupak Ganguly*
*   Add the compute_v2 instance helper method. *thanks Rupak Ganguly*
*   Add volume model, fix some mocks, and add volume tests. *thanks Rupak Ganguly*
*   Add request methods for snapshots, along with tests. *thanks Rupak Ganguly*
*   Add snapshot model along with tests. *thanks Rupak Ganguly*
*   Add request methods for volume backups, along with tests. *thanks Rupak Ganguly*
*   Fix status for request methods. *thanks Rupak Ganguly*
*   Add details to the volumes and snapshots collection. Add new helper methods for corresponding statuses. Add collection tests for volumes and snapshots. *thanks Rupak Ganguly*
*   Add volume backups model, along with tests. *thanks Rupak Ganguly*
*   Add a new Block Storage V2 provider for next gen block storage services. *thanks Rupak Ganguly*
*   Add request methods for volumes, along with tests. *thanks Rupak Ganguly*
*   Add the compute_v2 instance helper method. *thanks Rupak Ganguly*
*   Add volume model, fix some mocks, and add volume tests. *thanks Rupak Ganguly*
*   Add request methods for snapshots, along with tests. *thanks Rupak Ganguly*
*   Add snapshot model along with tests. *thanks Rupak Ganguly*
*   Add request methods for volume backups, along with tests. *thanks Rupak Ganguly*
*   Fix status for request methods. *thanks Rupak Ganguly*
*   Add details to the volumes and snapshots collection. Add new helper methods for corresponding statuses. Add collection tests for volumes and snapshots. *thanks Rupak Ganguly*
*   Add volume backups model, along with tests. *thanks Rupak Ganguly*

#### [hp|compute]
*   Add vnc console feature into request layer and server model. *thanks Rupak Ganguly*
*   Fix deprecation messaging. *thanks Rupak Ganguly*
*   Add vnc console feature into request layer and server model. *thanks Rupak Ganguly*
*   Fix deprecation messaging. *thanks Rupak Ganguly*

#### [hp|compute_v2]
*   Add new HP Compute V2 provider. Add request methods for servers. *thanks Rupak Ganguly*
*   Remove aweful caching from query. *thanks Rupak Ganguly*
*   Add filter options to query for servers. *thanks Rupak Ganguly*
*   Update attributes, mocks and inline help. *thanks Rupak Ganguly*
*   Add capability to pass networks while creating a server. *thanks Rupak Ganguly*
*   Add tests for request methods for server. *thanks Rupak Ganguly*
*   Add the request methods for reboot, rebuild and create_image for servers. *thanks Rupak Ganguly*
*   Add request methods for flavors, along with tests. *thanks Rupak Ganguly*
*   Add request methods for images, along with tests. *thanks Rupak Ganguly*
*   Add request methods for keypairs, along with tests. *thanks Rupak Ganguly*
*   Add metadata request methods for servers and images, along with tests. *thanks Rupak Ganguly*
*   Add request methods for console, along with tests. *thanks Rupak Ganguly*
*   Add request methods for floating ip addresses, along with tests. *thanks Rupak Ganguly*
*   Add request methods for server addresses, along with tests. *thanks Rupak Ganguly*
*   Add models for servers, images and metadata. *thanks Rupak Ganguly*
*   Add tests for servers, images and metadata. *thanks Rupak Ganguly*
*   Add models for flavors and key pairs, along with tests. *thanks Rupak Ganguly*
*   Add address model along with tests. *thanks Rupak Ganguly*
*   Fix some tests. *thanks Rupak Ganguly*
*   Fix mocks for server addresses. Fix create_server and server model to accept networks and availability zones params. *thanks Rupak Ganguly*
*   Add request methods and models for availability zones, along with tests. *thanks Rupak Ganguly*
*   Add request methods for volume attachments for server, along with tests. *thanks Rupak Ganguly*
*   Add volume attachment methods to the server model. *thanks Rupak Ganguly*
*   Add update_name for server model. *thanks Rupak Ganguly*
*   Update server model with flavor and image methods. Also, update the create_image method to return image model. Update tests as well. *thanks Rupak Ganguly*
*   Update rebuild method of the server model. *thanks Rupak Ganguly*
*   Refactor server model to add volume attachments. *thanks Rupak Ganguly*
*   Add method to retrieve windows instance password after it is created. Also, add tests for persistent server. *thanks Rupak Ganguly*
*   Fix network_name for 1.8.7 compatibility. *thanks Rupak Ganguly*
*   Add request method for limits. *thanks Rupak Ganguly*
*   Add request and server model methods to add security groups to server after creation, along with tests. *thanks Rupak Ganguly*
*   Fix a minor bug. *thanks Rupak Ganguly*
*   Add new HP Compute V2 provider. Add request methods for servers. *thanks Rupak Ganguly*
*   Remove aweful caching from query. *thanks Rupak Ganguly*
*   Add filter options to query for servers. *thanks Rupak Ganguly*
*   Update attributes, mocks and inline help. *thanks Rupak Ganguly*
*   Add capability to pass networks while creating a server. *thanks Rupak Ganguly*
*   Add tests for request methods for server. *thanks Rupak Ganguly*
*   Add the request methods for reboot, rebuild and create_image for servers. *thanks Rupak Ganguly*
*   Add request methods for flavors, along with tests. *thanks Rupak Ganguly*
*   Add request methods for images, along with tests. *thanks Rupak Ganguly*
*   Add request methods for keypairs, along with tests. *thanks Rupak Ganguly*
*   Add metadata request methods for servers and images, along with tests. *thanks Rupak Ganguly*
*   Add request methods for console, along with tests. *thanks Rupak Ganguly*
*   Add request methods for floating ip addresses, along with tests. *thanks Rupak Ganguly*
*   Add request methods for server addresses, along with tests. *thanks Rupak Ganguly*
*   Add models for servers, images and metadata. *thanks Rupak Ganguly*
*   Add tests for servers, images and metadata. *thanks Rupak Ganguly*
*   Add models for flavors and key pairs, along with tests. *thanks Rupak Ganguly*
*   Add address model along with tests. *thanks Rupak Ganguly*
*   Fix some tests. *thanks Rupak Ganguly*
*   Fix mocks for server addresses. Fix create_server and server model to accept networks and availability zones params. *thanks Rupak Ganguly*
*   Add request methods and models for availability zones, along with tests. *thanks Rupak Ganguly*
*   Add request methods for volume attachments for server, along with tests. *thanks Rupak Ganguly*
*   Add volume attachment methods to the server model. *thanks Rupak Ganguly*
*   Add update_name for server model. *thanks Rupak Ganguly*
*   Update server model with flavor and image methods. Also, update the create_image method to return image model. Update tests as well. *thanks Rupak Ganguly*
*   Update rebuild method of the server model. *thanks Rupak Ganguly*
*   Refactor server model to add volume attachments. *thanks Rupak Ganguly*
*   Add method to retrieve windows instance password after it is created. Also, add tests for persistent server. *thanks Rupak Ganguly*
*   Fix network_name for 1.8.7 compatibility. *thanks Rupak Ganguly*
*   Add request method for limits. *thanks Rupak Ganguly*
*   Add request and server model methods to add security groups to server after creation, along with tests. *thanks Rupak Ganguly*
*   Fix a minor bug. *thanks Rupak Ganguly*

#### [hp|dns]
*   Add the HP DNS provider along with the tests. *thanks Rupak Ganguly*
*   Add DNS model tests and updated models and mocks. *thanks Rupak Ganguly*
*   Fix update_record issue and fix tests. *thanks Rupak Ganguly*
*   Add the HP DNS provider along with the tests. *thanks Rupak Ganguly*
*   Add DNS model tests and updated models and mocks. *thanks Rupak Ganguly*
*   Fix update_record issue and fix tests. *thanks Rupak Ganguly*

#### [hp|dns,lb]
*   Add DNS and LB provider registration. *thanks Rupak Ganguly*
*   Add DNS and LB provider registration. *thanks Rupak Ganguly*

#### [hp|lb]
*   Add request layer for methods for load balancer along with tests. *thanks Rupak Ganguly*
*   Add HP provider models for Load Balancer along with tests. *thanks Rupak Ganguly*
*   Add request layer for methods for load balancer along with tests. *thanks Rupak Ganguly*
*   Add HP provider models for Load Balancer along with tests. *thanks Rupak Ganguly*

#### [hp|network]
*   Add the HP Network (Quantum) provider. *thanks Rupak Ganguly*
*   Add request method for list_networks. *thanks Rupak Ganguly*
*   Add request method for get_network. *thanks Rupak Ganguly*
*   Add request method for create_network. *thanks Rupak Ganguly*
*   Add request method for delete_network. *thanks Rupak Ganguly*
*   Add request method for update_network. *thanks Rupak Ganguly*
*   Add bin support for network provider. *thanks Rupak Ganguly*
*   Add tests for request methods for network provider. *thanks Rupak Ganguly*
*   Add request methods for subnets. *thanks Rupak Ganguly*
*   Add tests for request methods of subnets. *thanks Rupak Ganguly*
*   Add request methods for ports and tests to go along. *thanks Rupak Ganguly*
*   Update create_port to add security groups. *thanks Rupak Ganguly*
*   Minor edits. *thanks Rupak Ganguly*
*   Add the request methods for floating ips, along with the tests. *thanks Rupak Ganguly*
*   Minor chnages to inline docs and mocks. *thanks Rupak Ganguly*
*   Add the request methods for routers. *thanks Rupak Ganguly*
*   Fix the mocks for remove router logic. *thanks Rupak Ganguly*
*   Add tests for routers. *thanks Rupak Ganguly*
*   Add a mock external network. Fix some mocks and tests. *thanks Rupak Ganguly*
*   Add models for network, along with tests. *thanks Rupak Ganguly*
*   Minor changes to network model. *thanks Rupak Ganguly*
*   Add models for subnets, along with tests. *thanks Rupak Ganguly*
*   Add models for ports, along with tests. *thanks Rupak Ganguly*
*   Add models for floating ips, along with tests. *thanks Rupak Ganguly*
*   Add models for routers, along with tests. *thanks Rupak Ganguly*
*   Add router interface methods and tests to router models. *thanks Rupak Ganguly*
*   Fix minor bug. *thanks Rupak Ganguly*
*   Add request methods for networking security groups. *thanks Rupak Ganguly*
*   Add tests for request methods for networking security groups. *thanks Rupak Ganguly*
*   Add request methods for networking security group rules, along with tests. *thanks Rupak Ganguly*
*   Add models for security groups, along with tests. *thanks Rupak Ganguly*
*   Add security group rules model, along with tests. *thanks Rupak Ganguly*
*   Add a ready? method to the network model. *thanks Rupak Ganguly*
*   Add the request methods for floating ips, along with the tests. *thanks Rupak Ganguly*
*   Minor chnages to inline docs and mocks. *thanks Rupak Ganguly*
*   Add the request methods for routers. *thanks Rupak Ganguly*
*   Update network provider to cache credentials. *thanks Rupak Ganguly*
*   Add ready? method for port and router model. *thanks Rupak Ganguly*
*   Add a extra check for responses that return not JSON data. *thanks Rupak Ganguly*
*   Add the HP Network (Quantum) provider. *thanks Rupak Ganguly*
*   Add request method for list_networks. *thanks Rupak Ganguly*
*   Add request method for get_network. *thanks Rupak Ganguly*
*   Add request method for create_network. *thanks Rupak Ganguly*
*   Add request method for delete_network. *thanks Rupak Ganguly*
*   Add request method for update_network. *thanks Rupak Ganguly*
*   Add bin support for network provider. *thanks Rupak Ganguly*
*   Add tests for request methods for network provider. *thanks Rupak Ganguly*
*   Add request methods for subnets. *thanks Rupak Ganguly*
*   Add tests for request methods of subnets. *thanks Rupak Ganguly*
*   Add request methods for ports and tests to go along. *thanks Rupak Ganguly*
*   Update create_port to add security groups. *thanks Rupak Ganguly*
*   Minor edits. *thanks Rupak Ganguly*
*   Add the request methods for floating ips, along with the tests. *thanks Rupak Ganguly*
*   Minor chnages to inline docs and mocks. *thanks Rupak Ganguly*
*   Add the request methods for routers. *thanks Rupak Ganguly*
*   Fix the mocks for remove router logic. *thanks Rupak Ganguly*
*   Add tests for routers. *thanks Rupak Ganguly*
*   Add a mock external network. Fix some mocks and tests. *thanks Rupak Ganguly*
*   Add models for network, along with tests. *thanks Rupak Ganguly*
*   Minor changes to network model. *thanks Rupak Ganguly*
*   Add models for subnets, along with tests. *thanks Rupak Ganguly*
*   Add models for ports, along with tests. *thanks Rupak Ganguly*
*   Add models for floating ips, along with tests. *thanks Rupak Ganguly*
*   Add models for routers, along with tests. *thanks Rupak Ganguly*
*   Add router interface methods and tests to router models. *thanks Rupak Ganguly*
*   Fix minor bug. *thanks Rupak Ganguly*
*   Add request methods for networking security groups. *thanks Rupak Ganguly*
*   Add tests for request methods for networking security groups. *thanks Rupak Ganguly*
*   Add request methods for networking security group rules, along with tests. *thanks Rupak Ganguly*
*   Add models for security groups, along with tests. *thanks Rupak Ganguly*
*   Add security group rules model, along with tests. *thanks Rupak Ganguly*
*   Add a ready? method to the network model. *thanks Rupak Ganguly*
*   Add the request methods for floating ips, along with the tests. *thanks Rupak Ganguly*
*   Minor chnages to inline docs and mocks. *thanks Rupak Ganguly*
*   Add the request methods for routers. *thanks Rupak Ganguly*
*   Update network provider to cache credentials. *thanks Rupak Ganguly*
*   Add ready? method for port and router model. *thanks Rupak Ganguly*
*   Add a extra check for responses that return not JSON data. *thanks Rupak Ganguly*

#### [hp|storage]
*   Minor fixes to post_container and post_object methods and tests. *thanks Rupak Ganguly*
*   Add attributes to directory model and update collection to save these for the static web. *thanks Rupak Ganguly*
*   Add a metadata implementation for object storage directory. *thanks Rupak Ganguly*
*   Minor fixes to directory metadata and along with tests for metadata. *thanks Rupak Ganguly*
*   Minor fixes to post_container and post_object methods and tests. *thanks Rupak Ganguly*
*   Add attributes to directory model and update collection to save these for the static web. *thanks Rupak Ganguly*
*   Add a metadata implementation for object storage directory. *thanks Rupak Ganguly*
*   Minor fixes to directory metadata and along with tests for metadata. *thanks Rupak Ganguly*

#### [misc]
*   Fix parser typo that caused failure in #describe_internet_gateways when the gateway had tags. *thanks David Faber*
*   Add support to #create_tags mock for internet gateways. *thanks David Faber*
*   Fix initialization of instances array in AWS autoscaling group. *thanks David Faber*
*   Fix initialization of instances array in AWS autoscaling group. *thanks David Faber*
*   Remove override of instances instance-setting in autoscale groups. *thanks Jose Diaz-Gonzalez*
*   rake mock[<provider>] and live[<provider] tasks. *thanks Max Lincoln*
*   fix usage for mock. *thanks Max Lincoln*
*   added dns files. *thanks Mike Hagedorn*
*   added dns stuff. *thanks Mike Hagedorn*
*   added to bin for provider. *thanks Mike Hagedorn*
*   added lb to bin. *thanks Mike Hagedorn*
*   cleaned up dns stuff. *thanks Mike Hagedorn*
*   beginnings for LB adapter. *thanks Mike Hagedorn*
*   more requests... *thanks Mike Hagedorn*
*   versioning logic. *thanks Mike Hagedorn*
*   create lb node request logic. *thanks Mike Hagedorn*
*   clean up copy and paste error. *thanks Mike Hagedorn*
*   took dns refs out of lbaas branch. *thanks Mike Hagedorn*
*   model tweaks. *thanks Mike Hagedorn*
*   fixed request registration. *thanks Mike Hagedorn*
*   file rename. *thanks Mike Hagedorn*
*   added list tests. *thanks Mike Hagedorn*
*   added limits unit test. *thanks Mike Hagedorn*
*   get load balancer tests. *thanks Mike Hagedorn*
*   more node tests. *thanks Mike Hagedorn*
*   delete node/lb tests. *thanks Mike Hagedorn*
*   added dns files. *thanks Mike Hagedorn*
*   added dns stuff. *thanks Mike Hagedorn*
*   added to bin for provider. *thanks Mike Hagedorn*
*   added lb to bin. *thanks Mike Hagedorn*
*   cleaned up dns stuff. *thanks Mike Hagedorn*
*   beginnings for LB adapter. *thanks Mike Hagedorn*
*   more requests... *thanks Mike Hagedorn*
*   versioning logic. *thanks Mike Hagedorn*
*   create lb node request logic. *thanks Mike Hagedorn*
*   clean up copy and paste error. *thanks Mike Hagedorn*
*   took dns refs out of lbaas branch. *thanks Mike Hagedorn*
*   model tweaks. *thanks Mike Hagedorn*
*   fixed request registration. *thanks Mike Hagedorn*
*   file rename. *thanks Mike Hagedorn*
*   added list tests. *thanks Mike Hagedorn*
*   added limits unit test. *thanks Mike Hagedorn*
*   get load balancer tests. *thanks Mike Hagedorn*
*   more node tests. *thanks Mike Hagedorn*
*   delete node/lb tests. *thanks Mike Hagedorn*
*   make Disks model zone agnostic. *thanks Nat Welch*
*   small typo. *thanks Nat Welch*
*   expand variable names. *thanks Nat Welch*
*   added tests for monigtoring zones. *thanks Paul Vudmaska*
*   add pending if mocking to tests. *thanks Paul Vudmaska*
*   using Fog.mocking rather than mocking?. *thanks Paul Vudmaska*
*   Update changelog and bump version. *thanks Rupak Ganguly*
*   Fix minor thing. *thanks Rupak Ganguly*
*   Fix minor things in console request methods. *thanks Rupak Ganguly*
*   Minor fix to failing test. *thanks Rupak Ganguly*
*   Minor inline doc updates. *thanks Rupak Ganguly*
*   Minor fix to desc. of tests. *thanks Rupak Ganguly*
*   Minor fix to inline help. *thanks Rupak Ganguly*
*   Remove the metadata attribute, and let it be lazy loaded as needed per image object. *thanks Rupak Ganguly*
*   Add a capability to filter collections based on aliased or original attributes. Also, add capability to specify :details => true to fetch details, non-details call being the default. *thanks Rupak Ganguly*
*   Remove the metadata attribute, and let it be lazy loaded as needed per server object. *thanks Rupak Ganguly*
*   Add subnets collection to the network model. *thanks Rupak Ganguly*
*   Add a helper method for network_names. Also, update network_name methdo to set itself to the first network with a public ip address by default. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Minor fix to mocks. *thanks Rupak Ganguly*
*   Fix small typo. *thanks Rupak Ganguly*
*   [hp|compute_v2]Minor fixes to mocks. *thanks Rupak Ganguly*
*   Add a body for the request portion for the instrumentor. *thanks Rupak Ganguly*
*   Remove HP version info from user-agent. *thanks Rupak Ganguly*
*   Update newer providers to expose hp_service_type as was done in #2177. *thanks Rupak Ganguly*
*   Remove some files that were added during merge. *thanks Rupak Ganguly*
*   Update changelog and bump version. *thanks Rupak Ganguly*
*   Fix minor thing. *thanks Rupak Ganguly*
*   Fix minor things in console request methods. *thanks Rupak Ganguly*
*   Minor fix to failing test. *thanks Rupak Ganguly*
*   Minor inline doc updates. *thanks Rupak Ganguly*
*   Minor fix to desc. of tests. *thanks Rupak Ganguly*
*   Minor fix to inline help. *thanks Rupak Ganguly*
*   Remove the metadata attribute, and let it be lazy loaded as needed per image object. *thanks Rupak Ganguly*
*   Add a capability to filter collections based on aliased or original attributes. Also, add capability to specify :details => true to fetch details, non-details call being the default. *thanks Rupak Ganguly*
*   Remove the metadata attribute, and let it be lazy loaded as needed per server object. *thanks Rupak Ganguly*
*   Add subnets collection to the network model. *thanks Rupak Ganguly*
*   Add a helper method for network_names. Also, update network_name methdo to set itself to the first network with a public ip address by default. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Minor fix to mocks. *thanks Rupak Ganguly*
*   Fix small typo. *thanks Rupak Ganguly*
*   [hp|compute_v2]Minor fixes to mocks. *thanks Rupak Ganguly*
*   Add a body for the request portion for the instrumentor. *thanks Rupak Ganguly*
*   Remove HP version info from user-agent. *thanks Rupak Ganguly*
*   Update newer providers to expose hp_service_type as was done in #2177. *thanks Rupak Ganguly*
*   Remove some files that were added during merge. *thanks Rupak Ganguly*
*   Remove tests temporarily. *thanks Rupak Ganguly*
*   Fix tests temporarily for 1.8.7. *thanks Rupak Ganguly*
*   fixing firewall config to follow api documentation. *thanks Sneha Somwanshi*
*   Added missing health check uri and pool description. *thanks Sneha Somwanshi*
*   Should define the username only if empty. *thanks Sylvain Kalache*
*   Update lib/fog/hp.rb. *thanks Terry Howe*
*   Update lib/fog/hp/models/compute_v2/server.rb. *thanks Terry Howe*
*   Update lib/fog/hp/models/compute_v2/server.rb. *thanks Terry Howe*
*   fix error in volumes. *thanks Terry Howe*
*   Update create_record.rb. *thanks Terry Howe*
*   Update version.rb. *thanks Terry Howe*
*   Update versions.rb. *thanks Terry Howe*
*   make HP a bit more like openstack generic. *thanks Terry Howe*
*   changes to make old ips work better and activate network for HP. *thanks Terry Howe*
*   excon update fix. *thanks Terry Howe*
*   Update lib/fog/hp.rb. *thanks Terry Howe*
*   Update lib/fog/hp/models/compute_v2/server.rb. *thanks Terry Howe*
*   Update lib/fog/hp/models/compute_v2/server.rb. *thanks Terry Howe*
*   fix error in volumes. *thanks Terry Howe*
*   Update create_record.rb. *thanks Terry Howe*
*   Update version.rb. *thanks Terry Howe*
*   Update versions.rb. *thanks Terry Howe*
*   make HP a bit more like openstack generic. *thanks Terry Howe*
*   changes to make old ips work better and activate network for HP. *thanks Terry Howe*
*   excon update fix. *thanks Terry Howe*
*   When not mocked, test against LiveSpec api endpoint. *thanks Todd Willey*
*   Map a single-value hash to arrays when needed. *thanks Todd Willey*
*   Specify tests to come from Living Spec. *thanks Todd Willey*
*   add Chris Roberts to MVP list. *thanks geemus*
*   bump excon dependency. *thanks geemus*
*   syntax fix. *thanks geemus*
*   dxsdk-27 authentication caching. *thanks howete*
*   dxsdk-27 add the test back in. *thanks howete*
*   dxsdk-27 modification as pre rupak. *thanks howete*
*   dxsdk-27 make generic credentials. *thanks howete*
*   dxsdk-27 make generic credentials. *thanks howete*
*   dxsdk-321 add credentials for convenience methods. *thanks howete*
*   add a post object request for after and at deletes. *thanks howete*
*   correcting mock. *thanks howete*
*   dxsdk-335 add tests and a post_container request. *thanks howete*
*   monkey patch start. *thanks howete*
*   add service catalog call. *thanks howete*
*   merge. *thanks howete*
*   update LBaaS to what works with the current version in pro. *thanks howete*
*   make the updates for version and virtual ip. *thanks howete*
*   dxcli-847 fixes for 1.8.7 ruby. *thanks howete*
*   dxcli-847 add mikes tests back in. *thanks howete*
*   dxcli-863 versions error from fog call. *thanks howete*
*   dxsdk-27 authentication caching. *thanks howete*
*   dxsdk-27 add the test back in. *thanks howete*
*   dxsdk-27 modification as pre rupak. *thanks howete*
*   dxsdk-27 make generic credentials. *thanks howete*
*   dxsdk-27 make generic credentials. *thanks howete*
*   dxsdk-321 add credentials for convenience methods. *thanks howete*
*   add a post object request for after and at deletes. *thanks howete*
*   correcting mock. *thanks howete*
*   dxsdk-335 add tests and a post_container request. *thanks howete*
*   monkey patch start. *thanks howete*
*   add service catalog call. *thanks howete*
*   merge. *thanks howete*
*   update LBaaS to what works with the current version in pro. *thanks howete*
*   make the updates for version and virtual ip. *thanks howete*
*   dxcli-847 fixes for 1.8.7 ruby. *thanks howete*
*   dxcli-847 add mikes tests back in. *thanks howete*
*   dxcli-863 versions error from fog call. *thanks howete*

#### [rackspace]
*   fixing broken tests. *thanks Kyle Rames*

#### [rackspace|monitoring]
*   updating BadRequest exceptions to include validation errors. *thanks Kyle Rames*

#### [rackspace|storage]
*   implement get_http_url and get_https_url. See issue #2103 for more information. *thanks Kyle Rames*
*   set tests to pending if mocking. *thanks Kyle Rames*

#### [vcloud_director]
*   fix or skip tests that fail in real environment. *thanks Dan Abel*
*   test should fail fast, and use a clearly test id and description. *thanks Dan Abel*
*   Ensure task :Owner is always present. *thanks Nick Osborn*

#### [vsphere|compute]
*   Added the ability to create and destroy new volumes. *thanks Kevin Menard*
*   Be more intelligent about auto-picking a unit number for a volume. *thanks Kevin Menard*
*   Refresh the local volume attributes upon successful save and accurately report save failures. *thanks Kevin Menard*


## 1.17.0 10/29/2013
*Hash* 9f0627eec16e636bfe86895bbd36f89d7a017737

Statistic     | Value
------------- | --------:
Collaborators | 53
Downloads     | 3531286
Forks         | 964
Open Issues   | 177
Watchers      | 2765

**MVP!** Chris Roberts

#### [Brightbox]
*   Add SSL settings to load balancer. *thanks Paul Thornthwaite*

#### [aws|iam]
*   Don't pass :host to Excon request. *thanks Robert Bousquet*

#### [aws|storage]
*   ensure connection uses correct scheme, host and port. *thanks Brian D. Burns*
*   remove unused :path option. *thanks Brian D. Burns*

#### [core]
*   log warning for unrecognized arguments. *thanks Brian D. Burns*
*   identify origin of log messages. *thanks Brian D. Burns*
*   Make `ruby-libvirt` dependency optional. *thanks Paul Thornthwaite*

#### [google|compute]
*   examples tweaks. *thanks Nat Welch*
*   Fix externalIP setup. *thanks Nat Welch*

#### [google|storage]
*   ensure connection uses correct URI. *thanks Brian D. Burns*

#### [jruby]
*   Ignore failures until fully supported. *thanks Paul Thornthwaite*

#### [linode|compute]
*   Avoid passing host to request. *thanks Fletcher Nichol*

#### [linode|dns]
*   avoid passing host to request. *thanks geemus*

#### [misc]
*   Create a Snapshot based on a Disk. *thanks Akshay Moghe*
*   Add s3 bucket tagging support. *thanks Chris Roberts*
*   Add mocks in for bucket tagging and include in bucket tests. *thanks Chris Roberts*
*   Store tag information in mock and check for set tags in `put_bucket_tagging`. *thanks Chris Roberts*
*   Namespace tagging and move tagging tests prior to bucket deletion. *thanks Chris Roberts*
*   Return `body` out of test so we have proper value to match against expected `returns`. *thanks Chris Roberts*
*   Move mock storage initialization and remove storage checks. *thanks Chris Roberts*
*   AWS IAM userless key management. *thanks Jacob Burkhart & Shai Rosenfeld*
*   Removed errant :host argument. *thanks Jon Topper*
*   aws/compute: Hotfix, wrong Name argument for copy_image. *thanks Jonas Pfenniger*
*   Added testing in JRuby for Travis. *thanks Kevin Menard*
*   Don't load a couple MRI-only development dependencies on JRuby. *thanks Kevin Menard*
*   Temporary hack around #2279 to get fog loading on JRuby. *thanks Kevin Menard*
*   Added logging message for JRuby users to know they're at a disadvantage. *thanks Kevin Menard*
*   Scope the Unicode module so NameErrors make more sense. *thanks Kevin Menard*
*   Handle another case of the 'unicode' gem breaking things on JRuby. *thanks Kevin Menard*
*   Added a JRuby workaround in a test that's failing due to a JRuby bug. *thanks Kevin Menard*
*   Bound the 'myns' XML namespace to keep Nokogiri on JRuby happy. *thanks Kevin Menard*
*   Replaced the 'unicode' gem with 'unf' so it'll work with JRuby. *thanks Kevin Menard*
*   Made the 'unf' dependency optional. *thanks Kevin Menard*
*   Added a development dependency on 'unf' so the AWS escaping tests will pass. *thanks Kevin Menard*
*   Don't ignore JRuby failures in Travis any longer, since all known ones have been addressed. *thanks Kevin Menard*
*   Semantic Versioning (and Pessimistic Versioning Constraint) notice. *thanks Max Lincoln*
*   Update GCE to v1beta16. *thanks Nat Welch*
*   `@icco` can't spell. *thanks Nat Welch*
*   Fix bug in list images example. *thanks Nat Welch*
*   typo. *thanks Nat Welch*
*   Forgot to update Google Readme. *thanks Nat Welch*
*   allow custom hp_service_type. *thanks Omar Reiss*
*   applied hp_service_type fix on all services. *thanks Omar Reiss*
*   add v1 auth fix #2248. *thanks Peter Bonnell*
*   Add EnableLogging field to FirewallService XML. *thanks Philip Potter*
*   ensuring that edgegateway list elements are list. *thanks Sneha Somwanshi*
*   corrected name of edgegateway generator. *thanks Sneha Somwanshi*
*   tests for configure edge gateways. *thanks Sneha Somwanshi*
*   added comment on test. *thanks Sneha Somwanshi*
*   Add a reload() method to the vSphere service. *thanks Timur Alperovich*
*   Assign service to clone_result before new instance of vm. *thanks Xavier Fontrodona*
*   add end date for aws instance reservations. *thanks aabes*
*   - update compute api version to 2013/10/01      - add 'end' to described_reserved_instance. *thanks aabes*
*   fix mock for purchase ri. *thanks aabes*
*   Update create_server.rb. *thanks avic85*
*   Removed host params for excon connections. *thanks ccloes*
*   Invalid Excon request keys: :host, :port. *thanks wenlock*

#### [rackspace]
*   setting rackspace_region to nil in default tests to override any settings loaded via Fog.credentials. *thanks Kyle Rames*

#### [rackspace|block_storage]
*   fixing merge issue. *thanks Kyle Rames*

#### [vSphere]
*   Implemented feature to specify a socket cpu layout as specified in vmware API. If not used numCoresPerSocket is left out and default VMware behaviour is used.     [vSphere] also fixed bug in vm_reconfig_memory: wrong memory value passed to reconfig_hardware (memory in bytes instead of memory in MB). *thanks Marc Grimme*

#### [vcloud_director]
*   improoved tests for #ensure_list!. *thanks Dan Abel*
*   fixes so that non configured gateway are supported. *thanks Dan Abel*
*   Change input options structure. *thanks Nick Osborn*
*   strftime not iso8601 for ruby 1.8.7. *thanks Nick Osborn*
*   Mocking for tasks. *thanks Nick Osborn*
*   strftime not iso8601 for ruby 1.8.7. *thanks Nick Osborn*
*   Consistent usage of ensure_list! in get_disk. *thanks Nick Osborn*
*   Fix ruby 1.9-isms in media_tests. *thanks Nick Osborn*

#### [vsphere|compute]
*   Small code cleanup. *thanks Kevin Menard*
*   cleanup merge conflicts with clone method. *thanks Mick Pollard*


## 1.16.0 10/16/2013
*Hash* 13a86cd41e8ea10022fb822cb0b4340cbf2c023d

Statistic     | Value
------------- | --------:
Collaborators | 53
Downloads     | 3423389
Forks         | 951
Open Issues   | 178
Watchers      | 2751

**MVP!** Rodrigo Estebanez

#### [#2112]
*   Allows non VCR HTTP connections. *thanks Paul Thornthwaite*

#### [AWS|SQS]
*   Fix iam credentials not being refreshed. *thanks Frederick Cheung*

#### [Brightbox]
*   Servers can now have their groups updated. *thanks Hemant Kumar*
*   Switches to new format helper. *thanks Paul Thornthwaite*
*   Expands on some tests. *thanks Paul Thornthwaite*
*   Adds missing images attributes. *thanks Paul Thornthwaite*
*   Breaks schemas from test helper. *thanks Paul Thornthwaite*

#### [Rackspace|Load Balancers]
*   Added get_stats and mock for create_load_balancer. *thanks Michael Jackson*

#### [aws|autoscaling]
*   don't pass host to request. *thanks geemus*

#### [aws|compute]
*   remove :host from request parameters. *thanks Brian D. Burns*

#### [aws|sdb]
*   don't pass host to request. *thanks geemus*

#### [aws|storage]
*   mark post_object_restore test pending unless mocking. *thanks Brian D. Burns*

#### [cloudsigma|compute]
*   add firewall policies. *thanks fred-secludit*

#### [core]
*   removing uuidtools dependency; added Fog::UUID class. *thanks Kyle Rames*
*   updated UUID to use it's own UUID implementation if one was not available from the ruby lib. *thanks Kyle Rames*

#### [google]
*   Create zone and zones models. *thanks Carlos Sanchez*
*   Zone is a required parameter of machine_types request. *thanks Carlos Sanchez*
*   Add mock data. *thanks Carlos Sanchez*

#### [google|compute]
*   Set default zone to be one not in maintence. *thanks Nat Welch*
*   Update bootstrap image to debian-7-wheezy-v20130816. *thanks Nat Welch*
*   Fix metadata bug. *thanks Nat Welch*
*   Make sure we always set disk image size. *thanks Nat Welch*

#### [misc]
*   Local storage's File quacks like other Directories. *thanks Andy Lindeman*
*   Fixes SignatureDoesNotMatch error. *thanks Bradley Schaefer*
*   Adding example to bootstrap server with custom ssh_key. *thanks Brendan Fosberry*
*   require mime/types in Fog::Storage. *thanks Brian D. Burns*
*   Add fog Elasticache security group mocking. *thanks Brian Nelson*
*   Fix Fog::AWS::Elasticache::Mock#authorize_cache_security_group_ingress. *thanks Brian Nelson*
*   Fix for Mock AWS::Elasticache::SecurityGroup deletion. *thanks Brian Nelson*
*   Fixes for comments on pull request. *thanks Brian Nelson*
*   More fixes to AWS::Elasticache mocking. *thanks Brian Nelson*
*   Another fix from `@jbence` comments to simplify Excon response in authorize_cache_security_group_ingress. *thanks Brian Nelson*
*   Attempt to fix parameter group assignment when creating AWS::Elasticache clusters. *thanks Brian Nelson*
*   Only HTTPStatusError has request and response. *thanks Carlos Sanchez*
*   support retrieving edge gateway status. *thanks Dan Abel*
*   ensuring tests are good for empty orgs and are skipped when mocking. *thanks Dan Abel*
*   Mocks for get_edge_gateways & get edge gateway. *thanks Dan Abel*
*   Corrected edge_gateway schema and removed bad test. *thanks Dan Abel*
*   vcloud_director - improving edge gateway tests. *thanks Dan Abel*
*   Minor whitespace cleanups. *thanks Dan Prince*
*   All OpenStack heat requests must contain User/Key. *thanks Dan Prince*
*   Jsonify all OS orchestration requests. *thanks Dan Prince*
*   Fix orchestration request status codes. *thanks Dan Prince*
*   OpenStack orchestration update_stack fixes. *thanks Dan Prince*
*   Use ruby-style attribute setters in AutoScaling::Group initializer. *thanks David Faber*
*   Use old hash syntax to support older ruby versions. *thanks David Faber*
*   Fix for https urls in atmos. *thanks David Prater*
*   Fog::Storage::OpenStack::Real#put_object: Don't use data when block is provided. *thanks Dmitry Gutov*
*   Fog::Storage::OpenStack::Real#put_object: Document the block parameter     Fog::Storage::Rackspace::Real#put_object: Same. *thanks Dmitry Gutov*
*   Initial support for redshift, with describe_cluster requests and corresponding parsers. *thanks Efe Yardimci*
*   Adding the remaining describe requests. *thanks Efe Yardimci*
*   Support for create requests, along with parsers. *thanks Efe Yardimci*
*   Modify and Delete requests added. *thanks Efe Yardimci*
*   adding redshift to service list. *thanks Efe Yardimci*
*   Starting adding tests, some cleanup. *thanks Efe Yardimci*
*   refactoring common parser code. cluster requests tests. *thanks Efe Yardimci*
*   refactored duplicate parser code, added more request tests, converted all parser responses to be key,value pairs. *thanks Efe Yardimci*
*   marked mocking tests pending. *thanks Efe Yardimci*
*   Fix incorrect boolean expression; should have been string comparison. *thanks Efe Yardimci*
*   typo fix. *thanks Efe Yardimci*
*   openstack | add min_count, max_count, return_reservation_id. *thanks Eric Stonfer*
*   Update excon dependency to version ~>0.26.0. *thanks Erik Michaels-Ober*
*   Update vcr dependency to version ~>2.6. *thanks Erik Michaels-Ober*
*   Update webmock dependency to version ~>1.14. *thanks Erik Michaels-Ober*
*   Update excon dependency to version ~>0.27.0. *thanks Erik Michaels-Ober*
*   ec2 - added support for associating public ip with vpc instance on launch. *thanks Gabriel Rosendorf*
*   removed duplicate NetworkInterface.n.AssociatePublicIpAddress option. *thanks Gabriel Rosendorf*
*   cleaned up logic for multiple security groups for vpc instances with manually specified network interfaces. *thanks Gabriel Rosendorf*
*   added instance request and server model tests for associate_public_ip. *thanks Gabriel Rosendorf*
*   vpc associate_public_ip test. *thanks Gabriel Rosendorf*
*   Add alias for openstack availablilty zone server attribute. *thanks Greg Blomquist*
*   Adds backwards compatibility comment. *thanks Hendrik Volkmer*
*   Adding a few more ensure blocks for resource deletion. *thanks Jamie H*
*   Modifying array for 1.8.7 Gemfile to pass. *thanks Jamie H*
*   Removing trailing slashes from method calls for 1.8.7. *thanks Jamie H*
*   Fixing minor issues with doc annotations, removing unused file, adding Shindo tests. *thanks Jamie H*
*   Adding the red herrings. *thanks Jamie H*
*   Adding notifications for Rackspace Monitoring. *thanks Jim Salinas*
*   support for aws compute route tables. TODO: add mocks. *thanks Jon Palmer*
*   fixed route table parser. actually response data now. *thanks Jon Palmer*
*   added association_id to address model. *thanks Jon Palmer*
*   Quick doc update with some available EBS properties. *thanks Jon-Erik Schneiderhan*
*   Implement group_policy mocks and unit tests. *thanks Jose Luis Salas*
*   IAM::get_group_policy returns PolicyDocument Hash. *thanks Jose Luis Salas*
*   added put_record for dynect. *thanks Josh Blancett*
*   added shindo config for dynect put_record. *thanks Josh Blancett*
*   fixed typo. *thanks Josh Blancett*
*   added put_record to requests in dynect class. *thanks Josh Blancett*
*   added support for both update and replace for dynect put_record request. *thanks Josh Blancett*
*   fixed doc info. *thanks Josh Blancett*
*   fixed data formatting for testing dynect put_record. *thanks Josh Blancett*
*   refactors get_object_https_url request, adds temp_signed_url method to file class. *thanks Julian Weber*
*   adapts aws method signatures for temp url generation. *thanks Julian Weber*
*   refactors create_temp_url method to use the options hash for schemes instead of a parameter. *thanks Julian Weber*
*   adds object tests for get_http_url, get_https_url. *thanks Julian Weber*
*   Hp provider: ensures that hp_auth_version is loaded as symbol. *thanks Julian Weber*
*   changes sym conversion as discussed with rupakg. *thanks Julian Weber*
*   implements the get_http_url, get_https_url and url functions according to the openstack and aws providers. *thanks Julian Weber*
*   refactor: duplicate parsing of the storage_uri, file#url uses service.create_temp_url to be able to pass options now. *thanks Julian Weber*
*   adds :os_account_meta_temp_url_key to test mock helper. *thanks Julian Weber*
*   corrects object_tests, also working in mock mode now. *thanks Julian Weber*
*   Don’t escape '/' characters in keys. *thanks Keith Duncan*
*   Add support for canonicalising AWS keys. *thanks Keith Duncan*
*   Fix the Unicode strings for Ruby 1.8.7. *thanks Keith Duncan*
*   Pack takes Unicode characters, not UTF-8 encodings. *thanks Keith Duncan*
*   Added correct description comment to describe_route_tables, disassociate_route_table, delete_route, delete_route_table, create_route, and route_table(s) model. *thanks Kyla Kolb*
*   Created more tests for create_route and cleaned up code. *thanks Kyla Kolb*
*   Allowed vpc to be pending when in mock mode, fixed Boolean value for disassociate route table, excluded less specific cidr block for mock mode. *thanks Kyla Kolb*
*   removing unnecessary :hosts parameters from dynect and openstack requests. *thanks Kyle Rames*
*   Revert "[rackspace] updated shindo helper to add :rackspace_queues_client_id to credentials if it does not already exist. Hopefully this will make it easier to run Rackspace tests". *thanks Kyle Rames*
*   added uuidtools gem to dependencies. *thanks Kyle Rames*
*   support "name" on cloudstack deploy. *thanks Mark Phillips*
*   AWS Data Pipeline delete endpoint does not return a JSON body string. *thanks Matt Gillooly*
*   add support for AWS Data Pipeline's GetPipelineDefinition endpoint. *thanks Matt Gillooly*
*   add support for AWS Data Pipeline's QueryObjects endpoint. *thanks Matt Gillooly*
*   add support for AWS Data Pipeline's DescribeObjects endpoint. *thanks Matt Gillooly*
*   Add support for multiple sshkeys and downed zones. *thanks Nat Welch*
*   Added Coveralls.io coverage badge to README.md. *thanks Nick Merwin*
*   Revert "[vcloud_director] More mocking.". *thanks Nick Osborn*
*   Remove webmock. *thanks Nick Osborn*
*   Fix mocking for create server request. *thanks Reinaldo Junior*
*   added in mock for create_route_table. *thanks Robert Clark*
*   Added mocks for create_route_table and updated description comment. *thanks Robert Clark*
*   Added subnetId to describe_route_tables parser. *thanks Robert Clark*
*   Change routeTableSet to routeTable for createRouteTable, since it only returns one on creation, yet our mocks were not showing that same functionality. *thanks Robert Clark*
*   Updated description and added mock for associateRouteTable. *thanks Robert Clark*
*   Corrected description for createRoute to be more accurate. *thanks Robert Clark*
*   Setup VPC mocks to create a default route table. *thanks Robert Clark*
*   Added describe_route_tables mock. *thanks Robert Clark*
*   Removed state from route_table model because route_tables don't seem to have a state, routes do. Also fixes create_route_tables mock. *thanks Robert Clark*
*   Added network_interface_id and did a cleanup of create route. *thanks Robert Clark*
*   Fixed bug in parser where object memory reference was not being cleared. *thanks Robert Clark*
*   Updated routeSet to include all possible parameters, as some were being ignored by the parser. *thanks Robert Clark*
*   Added mock for create_route. *thanks Robert Clark*
*   Typo in default route. *thanks Robert Clark*
*   Do not wrap default route in item. *thanks Robert Clark*
*   Updated association to always contain optional fields. *thanks Robert Clark*
*   Added delete_route mock. *thanks Robert Clark*
*   Updated associate_route_table mock to return the correct association id and with additional fields that were previously missing. *thanks Robert Clark*
*   Added mock for disassociate_route_table. *thanks Robert Clark*
*   Added delete_route_table mock. *thanks Robert Clark*
*   Fixed error happening when the route_table was nil. *thanks Robert Clark*
*   Added spots to ignore for mocks in tests. *thanks Robert Clark*
*   Updated create route to make additional checks so it passed our tests. *thanks Robert Clark*
*   Cleaned up unnecessary parsers. *thanks Robert Clark*
*   Authentication + get_organizations working, need to be cleaned up. *thanks Rodrigo Estebanez*
*   get_organization implemented. *thanks Rodrigo Estebanez*
*   refactor get_organizations, not overriding the path, require parses in the request class. *thanks Rodrigo Estebanez*
*   get_catalog implemented. *thanks Rodrigo Estebanez*
*   get_catalog_item implemented. *thanks Rodrigo Estebanez*
*   get_vapp_template implemented. *thanks Rodrigo Estebanez*
*   clean-up. *thanks Rodrigo Estebanez*
*   get_vdc implemented. *thanks Rodrigo Estebanez*
*   fix defaults. *thanks Rodrigo Estebanez*
*   get_network implemented. *thanks Rodrigo Estebanez*
*   end_point helpers. *thanks Rodrigo Estebanez*
*   default_network_name. *thanks Rodrigo Estebanez*
*   clean-up. *thanks Rodrigo Estebanez*
*   implemented: default_organization_body, default_vdc_body, default_catalog_id, get_network_name_by_network_id. *thanks Rodrigo Estebanez*
*   instantiate_vapp_template before even test it. *thanks Rodrigo Estebanez*
*   get_app first implementation, parser isn't working properly. *thanks Rodrigo Estebanez*
*   parse description and links, remove non existing attar property. *thanks Rodrigo Estebanez*
*   Fix parser, adding links, and IsPublish attrs. *thanks Rodrigo Estebanez*
*   Fix get_network parser: adding IpRanges, Dns1, Dns2, DnsSuffix, RetainNetInfoAcrossDeployments, IsInherited     Implement String#to_bool. *thanks Rodrigo Estebanez*
*   clean-up mdsol domain. *thanks Rodrigo Estebanez*
*   GetOrganization sample comment. *thanks Rodrigo Estebanez*
*   using template_id instead of catalog_item_id. populate_uris and validate_uris implemented. *thanks Rodrigo Estebanez*
*   get_vapp_template parser. *thanks Rodrigo Estebanez*
*   parsed body as comment. *thanks Rodrigo Estebanez*
*   parsed body as comment. *thanks Rodrigo Estebanez*
*   parsed body as comment. *thanks Rodrigo Estebanez*
*   make clouding a fog service. *thanks Rodrigo Estebanez*
*   organization model working. *thanks Rodrigo Estebanez*
*   catalog and catalogs model. *thanks Rodrigo Estebanez*
*   catalog_items model. *thanks Rodrigo Estebanez*
*   vdc model implemented. *thanks Rodrigo Estebanez*
*   miscelanea. *thanks Rodrigo Estebanez*
*   adapting catalog to the new parser. *thanks Rodrigo Estebanez*
*   adapting organization to the new parser. *thanks Rodrigo Estebanez*
*   adapting catalog_item to the new parser. *thanks Rodrigo Estebanez*
*   adapting vdc to the new parser. *thanks Rodrigo Estebanez*
*   using new parser. *thanks Rodrigo Estebanez*
*   removing all parsers. *thanks Rodrigo Estebanez*
*   many changes... *thanks Rodrigo Estebanez*
*   remove parsers. clear debugging output. *thanks Rodrigo Estebanez*
*   vms and vm_customizations. *thanks Rodrigo Estebanez*
*   network request, parser and model implemented. *thanks Rodrigo Estebanez*
*   set_cpu implemented. *thanks Rodrigo Estebanez*
*   set memory and vm.reload. *thanks Rodrigo Estebanez*
*   modifying disk working. *thanks Rodrigo Estebanez*
*   add disk implemented. *thanks Rodrigo Estebanez*
*   delete disks. *thanks Rodrigo Estebanez*
*   disk model implemented, yeah!!. *thanks Rodrigo Estebanez*
*   vm customizations first try: it fails when it puts. *thanks Rodrigo Estebanez*
*   make vm_customization to work. *thanks Rodrigo Estebanez*
*   network and networks model implemented. *thanks Rodrigo Estebanez*
*   experiment with dynamic requests based on links. *thanks Rodrigo Estebanez*
*   tags implemented. *thanks Rodrigo Estebanez*
*   lot of small improvments. *thanks Rodrigo Estebanez*
*   Finally i got it fixed!!!. *thanks Rodrigo Estebanez*
*   power_on a vm. *thanks Rodrigo Estebanez*
*   power_on refactored to use process_task method. *thanks Rodrigo Estebanez*
*   instead of making the requests at save time, they are made when setting. *thanks Rodrigo Estebanez*
*   use only capacity= instead of save. *thanks Rodrigo Estebanez*
*   improved status. *thanks Rodrigo Estebanez*
*   using process_task. *thanks Rodrigo Estebanez*
*   process_task it accepts the body instead of the response excon object. *thanks Rodrigo Estebanez*
*   make the request when the value is set. *thanks Rodrigo Estebanez*
*   organizations refactored. *thanks Rodrigo Estebanez*
*   implementing lazy_load. *thanks Rodrigo Estebanez*
*   using NonLoaded class instead of nil. *thanks Rodrigo Estebanez*
*   make catalogs lazy_load. *thanks Rodrigo Estebanez*
*   using metaprogramming to automatically generate all the lazy_loader methods. *thanks Rodrigo Estebanez*
*   create a vcloud model class with the common code. *thanks Rodrigo Estebanez*
*   renamed everyone to lazy_load. *thanks Rodrigo Estebanez*
*   subclass to use the new Collection class. *thanks Rodrigo Estebanez*
*   using vcloud classes Model and Collection. *thanks Rodrigo Estebanez*
*   symbolize extract keys. *thanks Rodrigo Estebanez*
*   better naming of local vars. *thanks Rodrigo Estebanez*
*   refactor to user vcloud classes. *thanks Rodrigo Estebanez*
*   refactor vdc to use vcloud classes. *thanks Rodrigo Estebanez*
*   refactor vapp to use the vcloud classes. *thanks Rodrigo Estebanez*
*   refactor vm to use vcloud classes. *thanks Rodrigo Estebanez*
*   disks fully refactor to use the vcloud classes. *thanks Rodrigo Estebanez*
*   better erring. *thanks Rodrigo Estebanez*
*   string -> sym. *thanks Rodrigo Estebanez*
*   string -> sym. *thanks Rodrigo Estebanez*
*   tags refactored. *thanks Rodrigo Estebanez*
*   documentation. *thanks Rodrigo Estebanez*
*   devlab -> example.com. *thanks Rodrigo Estebanez*
*   basic vcloudng shindo test using VCR. *thanks Rodrigo Estebanez*
*   using a helper. *thanks Rodrigo Estebanez*
*   Tests organizations, vdcs, catalogs, catalog_items and RO vapps. *thanks Rodrigo Estebanez*
*   vm and vapp life cycle tests. *thanks Rodrigo Estebanez*
*   Adding VCR dependency in the gemspec. *thanks Rodrigo Estebanez*
*   webmock dependency added. *thanks Rodrigo Estebanez*
*   make tests 1.8.7 compatible. *thanks Rodrigo Estebanez*
*   make tests 1.8.7 compatible. *thanks Rodrigo Estebanez*
*   adding metadata support for vapp too. *thanks Rodrigo Estebanez*
*   Rename Vcloudng to VcloudDirector. *thanks Rodrigo Estebanez*
*   adding vapp_name to the vm model. *thanks Rodrigo Estebanez*
*   adding a hash_items method to show the tags as a hash. *thanks Rodrigo Estebanez*
*   Make VcloudDirector to support 5.1. Default version now is 5.1. *thanks Rodrigo Estebanez*
*   get_vms_by_metadata. *thanks Rodrigo Estebanez*
*   clean-up. *thanks Rodrigo Estebanez*
*   returns the vapp_id instead of true. *thanks Rodrigo Estebanez*
*   memory is an integer     Conflicts:     	lib/fog/vcloud_director/models/compute/vm.rb. *thanks Rodrigo Estebanez*
*   adding ready? method     Conflicts:     	lib/fog/vcloud_director/models/compute/vm.rb. *thanks Rodrigo Estebanez*
*   accessing to the parent vapp even if the vm is orphan (query result)     Conflicts:     	lib/fog/vcloud_director/models/compute/vm.rb. *thanks Rodrigo Estebanez*
*   defaults are set when the param is not passed. *thanks Rodrigo Estebanez*
*   Fix: tags implementation was defective. *thanks Rodrigo Estebanez*
*   each_with_index makes it more concise. *thanks Rodrigo Estebanez*
*   reverting back. tags is a hash. *thanks Rodrigo Estebanez*
*   vcloud_director customization syntax Fix: extra comma was preventing to set the status correctly. *thanks Rodrigo Estebanez*
*   remove instantiate_vapp_template helper dependencies     require vdc_id as a instantiate_vapp_template param     remove unnecessary helper. *thanks Rodrigo Estebanez*
*   - make tags model to use post_undeploy_vapp     - fix syntax error in post_undeploy_vapp method     - remove post_vm_metadata. *thanks Rodrigo Estebanez*
*   fix invalid syntax. *thanks Rodrigo Estebanez*
*   fix situation where the content of the param can be false and not set the attr. *thanks Rodrigo Estebanez*
*   add list_entities request mock. *thanks Ryan Richard*
*   add create_entity mock support. *thanks Ryan Richard*
*   add create_entity failure support. *thanks Ryan Richard*
*   add get_entity mock support. *thanks Ryan Richard*
*   add delete_entity mock support. *thanks Ryan Richard*
*   add update_entities mock support, minor change to variables in Real. *thanks Ryan Richard*
*   add create_alarm mock support. *thanks Ryan Richard*
*   minor change to failure condition. *thanks Ryan Richard*
*   update to obfuscate various IDs in tests. *thanks Ryan Richard*
*   list_alarm and get_alarm mock support. *thanks Ryan Richard*
*   add update_alarm mock support, update Real parameters to convention. *thanks Ryan Richard*
*   delete_alarm mock support. *thanks Ryan Richard*
*   obfuscate more data. *thanks Ryan Richard*
*   obfuscate all entity mocks. *thanks Ryan Richard*
*   enable 2 failure tests, minor obfuscates. *thanks Ryan Richard*
*   fix missing response.remote_ip. *thanks Ryan Richard*
*   mock framework for list_data_points. *thanks Ryan Richard*
*   list_data_points mock support. *thanks Ryan Richard*
*   one last obfuscate pass. *thanks Ryan Richard*
*   fix missing record data in dynect dns. *thanks Shawn Catanzarite*
*   remove commented code and update API version. *thanks Shawn Catanzarite*
*   add get_node_list request again, add test for get_all_records request. *thanks Shawn Catanzarite*
*   speed things up for get calls. add find_by_name filter. still needs some refactoring. *thanks Shawn Catanzarite*
*   remove find_by_name for now. *thanks Shawn Catanzarite*
*   options not used. return nil unless we find a matching url in response. *thanks Shawn Catanzarite*
*   fix for - fog fails to load vdc with 1 or 0 vapps. *thanks Sneha Somwanshi*
*   corrected the check for empty string. *thanks Sneha Somwanshi*
*   vapp returns false if power action returns bad_request. *thanks Sneha Somwanshi*
*   fixing typo in raising exception. *thanks Sneha Somwanshi*
*   vm should return false if power action returns bad_request. *thanks Sneha Somwanshi*
*   first cut - configuring firewall edgegateway service. *thanks Sneha Somwanshi*
*   posting xml to configure nat service. *thanks Sneha Somwanshi*
*   adding optional fields for nat and firewall service. *thanks Sneha Somwanshi*
*   configuring load balancer service. *thanks Sneha Somwanshi*
*   element type is not required , when href is provided. *thanks Sneha Somwanshi*
*   renamed service post method according to documentation. *thanks Sneha Somwanshi*
*   broke generator code into smaller methods. *thanks Sneha Somwanshi*
*   moved method up in alphabetical order. *thanks Sneha Somwanshi*
*   using Camel case for edgegateway configuration. *thanks Sneha Somwanshi*
*   removed print statements added for debugging. *thanks Sneha Somwanshi*
*   generalize server and floating ip create. *thanks Terry Howe*
*   formatting clean up. *thanks Thomas Cate*
*   added create_agent test. *thanks Thomas Cate*
*   added delete_agent_token tests. *thanks Thomas Cate*
*   fixed failure test for create_agent_token. *thanks Thomas Cate*
*   fixed failure test for delete_agent_token. *thanks Thomas Cate*
*   finished all token tests. *thanks Thomas Cate*
*   added mock data for check tests. *thanks Thomas Cate*
*   added list_checks and list_check_types mocks. *thanks Thomas Cate*
*   added list_metrics. *thanks Thomas Cate*
*   added list_overview mock. *thanks Thomas Cate*
*   use mock for ip info. *thanks Thomas Cate*
*   use fog mock data for uuid and entity_id. *thanks Thomas Cate*
*   added list_notification_plans mock data. *thanks Thomas Cate*
*   Support filters in images collection. *thanks Thomas Kadauke*
*   Fix test. *thanks Thomas Kadauke*
*   Pass on filters to volume endpoint, mainly to allow admin to get volumes from all tenants. *thanks Thomas Kadauke*
*   CRUD for OpenStack heat's Stack model. *thanks Thomas Kadauke*
*   Tests for previous commit. *thanks Thomas Kadauke*
*   Store mock stacks in memory to make tests more realistic. *thanks Thomas Kadauke*
*   Grab parse flag before it hits the connection. *thanks Toby Hede*
*   Delete invalid connection keys before request is made. *thanks Toby Hede*
*   Add Atmos meta_data request and file_size. *thanks Toby Hede*
*   Allow passing Content-Disposition header when saving file into Openstack cloud. *thanks Yauheni Kryudziuk*
*   Create list_snapshot_images.rb. *thanks dJason*
*   Update list_images.rb. *thanks dJason*
*   Update images.rb. *thanks dJason*
*   Update images.rb. *thanks dJason*
*   Delete list_snapshot_images.rb. *thanks dJason*
*   Update list_images.rb. *thanks dJason*
*   add mock. *thanks fred-secludit*
*   adding new models. *thanks fred-secludit*
*   fix / escaping in AWS param signing. *thanks geemus*
*   fix S3 vs EC2 escaping differences. *thanks geemus*
*   tighten mime-types dependency for 1.8.7. *thanks geemus*
*   Strip new lines from PackedPolicySize response from GetFederationToken. *thanks gregburek*
*   Add minimal documentation in GetFederationToken request. *thanks gregburek*
*   Add mocks for GetFederationToken and enable use. *thanks gregburek*
*   Adding models, collections and making a start on request classes. *thanks jamiehannaford*
*   Initial commit for Rackspace's new Autoscale features. Most functionality is incorporated, including:     - Scaling groups     - Configuration (group configuration and launch configuration)     - Scaling policies     - Webhooks. *thanks jamiehannaford*
*   Removing two superfluous files. *thanks jamiehannaford*
*   Shindo tests are completed; finished adding Mock data. *thanks jamiehannaford*
*   fix for linode using public ip blocks in 192.*. *thanks jblancett*
*   Add ability to specify availability zone for subnet during creation. *thanks jschneiderhan*

#### [openstack]
*   remove :host from Excon request params. *thanks Brian D. Burns*
*   make a couple storage tests pending if mocking. *thanks Kyle Rames*

#### [openstack|compute]
*   Add support for config_drive. *thanks Ferran Rodenas*

#### [openstack|storage]
*   remove deprecated response block from request. *thanks Brian D. Burns*
*   add default Accept header. *thanks Brian D. Burns*
*   add #delete_multiple_objects. *thanks Brian D. Burns*
*   patch #delete_multiple_objects for Swift v1.8. *thanks Brian D. Burns*
*   add methods for SLO support. *thanks Brian D. Burns*
*   add #put_dynamic_obj_manifest. *thanks Brian D. Burns*
*   patch #delete_static_large_object for Swift v1.8. *thanks Brian D. Burns*

#### [rackpace|auto_scale]
*   adding missing require for group builder in tests. *thanks Kyle Rames*

#### [rackspace]
*   remove deprecated response block from request. *thanks Brian D. Burns*
*   Don't parse JSON in delete_server. *thanks David Wittman*
*   A test to reveal a bug in server.create. *thanks Joonas Reynders*
*   Fixes issue #2187 Compute.servers.bootstrap mutates the :networks option. *thanks Joonas Reynders*
*   fixing broken tests. *thanks Kyle Rames*
*   fixing connection deprecation warnings. *thanks Kyle Rames*
*   fixing resize server test; updated server test to make network deletion more robust. *thanks Kyle Rames*
*   fixes issue #2080 - Recursive loop in rackspace compute authentication. *thanks Kyle Rames*
*   making server tests more robust. *thanks Kyle Rames*
*   removing debug puts. *thanks Kyle Rames*
*   updating to only parse json if the body of the response has data. *thanks Kyle Rames*
*   hardcoding flavor_id used by mock data. *thanks Kyle Rames*
*   removing :host from list of request parameters. See PR #2223 for details. *thanks Kyle Rames*
*   moved LINKS_FORMAT to top level helper as it is used by multiple specs. *thanks Kyle Rames*
*   updated shindo helper to add :rackspace_queues_client_id to credentials if it does not already exist. Hopefully this will make it easier to run Rackspace tests. *thanks Kyle Rames*
*   removing :host key from authentication_v1 requests. *thanks Kyle Rames*
*   fix excluding extra characters in Rackspace.escape. *thanks Sami Samhuri*
*   fix non-SSL public CDN URLs. *thanks Sami Samhuri*

#### [rackspace|auto scale]
*   fixed update method on launch config; added save and reload method. *thanks Kyle Rames*

#### [rackspace|auto_scale]
*   renamed the model tests to follow fog conventions. *thanks Kyle Rames*
*   fixed a bug retrieving sub-objects of group. *thanks Kyle Rames*
*   fixed bug with group_config.update; added save and reload method. *thanks Kyle Rames*
*   added transaction ids to exceptions. *thanks Kyle Rames*
*   added implementation for resume. *thanks Kyle Rames*
*   updating policy to have a reference to the group rather than the group_id. *thanks Kyle Rames*
*   fixing formatting. *thanks Kyle Rames*
*   added a save method to policy. *thanks Kyle Rames*
*   added save method to webhook. *thanks Kyle Rames*
*   adding autoscale examples. *thanks Kyle Rames*
*   fixing formatting and documentation; updated collections to pass along dependent parent models. *thanks Kyle Rames*
*   adding examples. *thanks Kyle Rames*
*   adding tests. *thanks Kyle Rames*
*   fixing tests. *thanks Kyle Rames*
*   fixing example formatting. *thanks Kyle Rames*
*   updated to throw an exception if you try to save a persisted group. *thanks Kyle Rames*
*   marking group tests as pending if mocking. *thanks Kyle Rames*
*   tweaking syntax for ruby 1.8.7. *thanks Kyle Rames*
*   update create scaling group to use GroupBuilder. *thanks Kyle Rames*
*   adding auto scale getting started doc. *thanks Kyle Rames*
*   updating getting started docs. *thanks Kyle Rames*
*   fixing 1.8.7 incompatibility. *thanks Kyle Rames*

#### [rackspace|auto_scaling]
*   making policy and web hook model tests pending if mocking. *thanks Kyle Rames*

#### [rackspace|autoscale]
*   starting on rackspace auto scale implementation. *thanks Kyle Rames*
*   updating tests to reflect formatting changes. *thanks Kyle Rames*

#### [rackspace|block_storage]
*   updated Volume#create to honor snapshot_id attribute. *thanks Kyle Rames*

#### [rackspace|blockstrage]
*   fixed mock error. *thanks Eugene Howe*

#### [rackspace|compute]
*   fixing broken tests. *thanks Kyle Rames*
*   switching default compute provider to Fog::Compute::RackspaceV2. *thanks Kyle Rames*

#### [rackspace|compute_v2]
*   Flavor list returns details. *thanks Chris Wuest*
*   Image list returns details. *thanks Chris Wuest*
*   tests for new requests. *thanks Chris Wuest*
*   fixing broken test. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   adding private network creation/deletion examples. *thanks Kyle Rames*
*   removing parent requirement from new method as it prevents us from creating metadata on new servers. *thanks Kyle Rames*

#### [rackspace|databases]
*   updating requests to support schema changes. *thanks Kyle Rames*

#### [rackspace|load balancers]
*   fixing broken test. *thanks Kyle Rames*

#### [rackspace|monitoring]
*   adding mocks for get_entity. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*

#### [rackspace|queueing]
*   Cleaned up tests and authentication logic. *thanks Brian Hartsock*

#### [rackspace|queues]
*   Addition of Rackspace Cloud Queues. *thanks Brian Hartsock*
*   Fixed some PR comments;  Pass more information to underlying exceptions. *thanks Brian Hartsock*
*   Added :rackspace_queues_client_id to tests to make it easier to run; Couple other PR tweaks. *thanks Brian Hartsock*
*   fixed broken tests. *thanks Brian Hartsock*
*   updated Fog::Rackspace::Queues to generate UUID for client id if it is not provided with one. *thanks Kyle Rames*
*   updated to use FOG::UUID. *thanks Kyle Rames*

#### [rackspace|storage]
*   fixed broken object test. *thanks Kyle Rames*

#### [vSphere]
*   Support passing of a distributed switch for each interface. *thanks Marc Grimme*
*   Support datacenters that are located below folders not in root folder. *thanks Marc Grimme*

#### [vSphere:]
*   Implementation of Query for Guesttype and NICTypes. *thanks Marc Grimme*

#### [vcloud_director]
*   tests for #ensure_list!. *thanks Dan Abel*
*   Use options in instantiate. *thanks Nick Osborn*
*   'Set-Cookie' may be lowercase. *thanks Nick Osborn*
*   Fix module name. *thanks Nick Osborn*
*   Allow for multiple Orgs. *thanks Nick Osborn*
*   make available to Fog::Bin. *thanks Nick Osborn*
*   add keys to Errors.missing_credentials. *thanks Nick Osborn*
*   Improve support for Tasks. *thanks Nick Osborn*
*   Fix copy & paste fail. *thanks Nick Osborn*
*   Allow for multiple Orgs, rephrased. *thanks Nick Osborn*
*   Integrate tests. *thanks Nick Osborn*
*   Deconflate Org name and FullName. *thanks Nick Osborn*
*   Capture org name at login. *thanks Nick Osborn*
*   whitespace cleanup. *thanks Nick Osborn*
*   Update README. *thanks Nick Osborn*
*   Start mocking requests. *thanks Nick Osborn*
*   Add get_supported_versions request. *thanks Nick Osborn*
*   Better mocking and documentation. *thanks Nick Osborn*
*   Fix minor documentation typo. *thanks Nick Osborn*
*   Set :idempotent on GET requests. *thanks Nick Osborn*
*   More mocking. *thanks Nick Osborn*
*   Correct docs for get_catalog_item. *thanks Nick Osborn*
*   More mocking (1.8.7 compliant). *thanks Nick Osborn*
*   Add media-related requests. *thanks Nick Osborn*
*   Add basic media model. *thanks Nick Osborn*
*   Add tests for task model. *thanks Nick Osborn*
*   Request method renaming. *thanks Nick Osborn*
*   Add media(s) to README. *thanks Nick Osborn*
*   Add get_supported_systems_info request. *thanks Nick Osborn*
*   Add remaining vApp/VM power actions. *thanks Nick Osborn*
*   Properly rename undeploy -> post_undeploy_vapp. *thanks Nick Osborn*
*   fix vapp#suspend. *thanks Nick Osborn*
*   Fix :UndeployPowerAction in post_undeploy_vapp. *thanks Nick Osborn*
*   Add get_*_ovf_descriptor methods. *thanks Nick Osborn*
*   Add post_capture_vapp request. *thanks Nick Osborn*
*   New & refactored XML generators. *thanks Nick Osborn*
*   Add #create to medias collection. *thanks Nick Osborn*
*   Use post_undeploy_vapp. *thanks Nick Osborn*
*   Use post_undeploy_vapp. *thanks Nick Osborn*
*   Don't pass :host to request. *thanks Nick Osborn*
*   Implement more API requests. *thanks Nick Osborn*
*   Use x-vcloud-authorization header. *thanks Nick Osborn*
*   Implement get*_metadata_item requests. *thanks Nick Osborn*
*   Remove vcr. *thanks Nick Osborn*
*   Cater for email`@org_name` usernames. *thanks Nick Osborn*
*   Yet more request methods. *thanks Nick Osborn*
*   Move parser commentary out of top-level docs. *thanks Nick Osborn*
*   Make test be less chatty. *thanks Nick Osborn*
*   Use current_org in edge_gateway_tests. *thanks Nick Osborn*
*   Supply xmlns with request bodies. *thanks Nick Osborn*
*   Improve tests. *thanks Nick Osborn*
*   Add post/put metadata methods. *thanks Nick Osborn*
*   get_edge_gateways -> get_org_vdc_networks. *thanks Nick Osborn*
*   Make get_edge_gateway idempotent. *thanks Nick Osborn*
*   Really make GET requests idempotent. *thanks Nick Osborn*
*   Implement get_thumbnail request. *thanks Nick Osborn*
*   Documentation fixes. *thanks Nick Osborn*
*   Mocking for vDC storage profiles. *thanks Nick Osborn*
*   Expose URLs in method docs. *thanks Nick Osborn*
*   Add post_instantiate_vapp_template request. *thanks Nick Osborn*
*   Improve support for query service. *thanks Nick Osborn*
*   Raise provider-specific exceptions. *thanks Nick Osborn*
*   Remove extraneous :. *thanks Nick Osborn*
*   Call `end_point` not `endpoint`. *thanks Nick Osborn*
*   Explicitly handle duplicate names. *thanks Nick Osborn*
*   Add general queries handler. *thanks Nick Osborn*
*   Support fields,filter,format for packaged queries. *thanks Nick Osborn*
*   Do ensure_list in request methods. *thanks Nick Osborn*
*   Minor test cleanups. *thanks Nick Osborn*
*   Add #get_org_settings and #get_vcloud. *thanks Nick Osborn*
*   Add #post_answer_vm_pending_question. *thanks Nick Osborn*
*   Add #put_vm_capabilities. *thanks Nick Osborn*
*   Fancy progress bar for async tasks. *thanks Nick Osborn*
*   Doc update for get,put_vm_capabilities. *thanks Nick Osborn*
*   Parse response in #put_vm_capabilities. *thanks Nick Osborn*
*   Add ability to undeploy vApp. *thanks Philip Potter*
*   wait for undeploy to finish before returning. *thanks Philip Potter*
*   rename undeploy.rb to match other request files. *thanks Philip Potter*
*   Add power_off for vm. *thanks rsalm*
*   Added power_on, power_off to vApp. *thanks rsalm*
*   Fix listing catalog items when only a single item exists. *thanks rsalm*
*   Added support for deleting vApps. *thanks rsalm*
*   Implement vapp.destroy and get rid off vdc.delete_vapp. *thanks rsalm*
*   Move ensure_list to VCloudDirector::Collection.     Replace inline wrap implementations in Tasks and Organizations with     ensure_list. *thanks rsalm*

#### [vcloud_director|tests]
*   Remove vcr_cassettes_old/. *thanks Nick Osborn*
*   Don't hardcode API host. *thanks Nick Osborn*
*   mv *_test.rb *.tests.rb. *thanks Nick Osborn*
*   Make tests work. *thanks Nick Osborn*
*   Remove and ignore vcr_cassettes/. *thanks Nick Osborn*
*   Avoid warning about username. *thanks Nick Osborn*
*   Add generator tests. *thanks Nick Osborn*
*   Fix some edge cases. *thanks Nick Osborn*
*   Mark media tests pending when mocking. *thanks Nick Osborn*


## 1.15.0 08/16/2013
*Hash* 73c5497a16a5374b6bec2f533da872aee682a73a

Statistic     | Value
------------- | --------:
Collaborators | 50
Downloads     | 2932167
Forks         | 891
Open Issues   | 165
Watchers      | 2679

**MVP!** Daniel Reichert

#### [AWS]
*   print out raw response string when DEBUG_RESPONSE env var is set. *thanks Michael Hale*

#### [AWS|ASG]
*   filtering for ASG Scaling Policies. *thanks Blake Gentry*
*   filtering for ASG Scaling Activities. *thanks Blake Gentry*
*   parse ScalingPolicy MinAdjustmentStep. *thanks Blake Gentry*
*   filtering for ASGs. *thanks Blake Gentry*
*   filter mocked results for describe_auto_scaling_groups. *thanks Blake Gentry*
*   filter mocked results for describe_auto_scaling_policies. *thanks Blake Gentry*

#### [AWS|ELB]
*   add ProxyProtocolPolicyType (and formatting). *thanks Michael Hale*
*   add set_load_balancer_policies_for_backend_server request. *thanks Michael Hale*
*   add support for seeing backend server descriptions. *thanks Michael Hale*
*   add support for OtherPolicies. *thanks Michael Hale*
*   fix InstancePort parsing in describe_load_balancers. *thanks Michael Hale*
*   load_balancer_tests cleanup cert from potentially failed previous test run. *thanks Michael Hale*
*   test describe_load_balancers parser directly. *thanks Michael Hale*
*   emulate AWS behavior: no BackendServerDescriptions by default. *thanks Michael Hale*
*   fix set_load_balancer_polices_for_backend mock to track set BackgroundServerDescriptions. *thanks Michael Hale*
*   update helper to include BackendServerDescriptions and OtherPolicies. *thanks Michael Hale*
*   fix backend server descriptions model test.     Reload the elb to pickup the latest descriptions. *thanks Michael Hale*
*   mocks emulate AWS behavior     when setting a policy for the backend server a subsequent describe is     required to update the local state with the current BackendServerDescriptions. *thanks Michael Hale*
*   fix PolicyTypeNotFound error in create_load_balancer_policy mock. *thanks Michael Hale*
*   policy model and collection support creating and showing OtherPolicies. *thanks Michael Hale*
*   fetch policy descriptions for elb.policies model call. *thanks Michael Hale*
*   actually check PublicKey. *thanks Michael Hale*
*   use ['Policies']['Proper'] as the canonical mock policy store. *thanks Michael Hale*
*   remove unused bits. *thanks Michael Hale*
*   check the result of describe_load_balancer_polices for each policy by name. *thanks Michael Hale*
*   test that describe_load_balancers mocks properly formats policy results. *thanks Michael Hale*
*   restore policy.cookie and policy.expiration methods. *thanks Michael Hale*

#### [Brightbox]
*   Fixes service deprecations. *thanks Paul Thornthwaite*
*   Updates to collaboration models. *thanks Paul Thornthwaite*

#### [Cloudstack|Compute]
*   Add support for keypair and userdata when creating cloudstack vms. *thanks Christophe Roux*

#### [Vcloud]
*   Adding case insensitivity for set-cookie header. *thanks Garima Singh*

#### [aws|elb]
*   add new style default security group. *thanks Eugene Howe*

#### [aws|iam]
*   Make mock EntityAlreadyExists message match reality. *thanks Dan Peterson*

#### [core]
*   excluded :headers hash from symbolize_credentials in order to properly pass headers onto Excon. *thanks Kyle Rames*
*   exclude :headers from symbolization for real this time; added better tests; Thanks `@burns!.` *thanks Kyle Rames*

#### [glesys]
*   added options to resuse ip and/or ipv6 and description. *thanks Andreas Josephson*

#### [google]
*   Add support for network and external_ip. *thanks Romain Vrignaud*
*   client.images doesn't list google public images. *thanks Romain Vrignaud*
*   Add support for network and external_ip. *thanks Romain Vrignaud*

#### [google-compute-engine]
*   Add private_ip_address method for server. *thanks Romain Vrignaud*

#### [google|compute]
*   Fix insert disk to deal with changes to insert image. *thanks Nat Welch*
*   servers.get don't catch errors. *thanks Romain Vrignaud*
*   disks.all shouldn't return nil. *thanks Romain Vrignaud*
*   fix typo on disk example. *thanks Romain Vrignaud*
*   zone in disks.get is now optional. *thanks Romain Vrignaud*
*   better check on server.public_ip_address. *thanks Romain Vrignaud*

#### [misc]
*   Accept public_key and public_key_path when creating GCE server. *thanks Akshay Moghe*
*   Query global projects when get/list'ing compute images. *thanks Akshay Moghe*
*   Allow users to create images in GCE. *thanks Akshay Moghe*
*   Add 'status' attribute to GCE images. *thanks Akshay Moghe*
*   When 'insert'ing a disk, don't try to create an image. *thanks Akshay Moghe*
*   Add ability to get/list snapshots in GCE. *thanks Akshay Moghe*
*   Align the disk interface more closely with the API. *thanks Akshay Moghe*
*   Fix up the 'disk' api. *thanks Akshay Moghe*
*   Rackspace: add keypair support. *thanks Bart Vercammen*
*   AWS: remove logging. *thanks Bart Vercammen*
*   rackspace keypairs: add some Mocks. *thanks Bart Vercammen*
*   rename function 'get_key' => 'get_keypair'. *thanks Bart Vercammen*
*   Rackspace: add keypair support. *thanks Bart Vercammen*
*   rackspace keypairs: add some Mocks. *thanks Bart Vercammen*
*   rename function 'get_key' => 'get_keypair'. *thanks Bart Vercammen*
*   rackspace: create_server - API change: options[:keypair] takes String i.s.o. Hash (-> the keypair name). *thanks Bart Vercammen*
*   rackspace: keypairs - add unit tests. *thanks Bart Vercammen*
*   rackspace:keypairs - add 'model' unit tests. *thanks Bart Vercammen*
*   rackspace:kaypair - small corrections during unit test. *thanks Bart Vercammen*
*   rackspace: keypairs - throw Fog::Compute::RackspaceV2::NotFound when HTTP:404 received. *thanks Bart Vercammen*
*   rackspace: keypairs - additional unittests + correct keypairs.destroy behaviour. *thanks Bart Vercammen*
*   rackspace - keypairs : redo exception/no-exception logic for ::destroy and ::get functions. *thanks Bart Vercammen*
*   rackspace: keypairs - add documentation. *thanks Bart Vercammen*
*   Protect against missing fields in rackspace endpoint documents. *thanks Brendan Fosberry*
*   Added rackspace monitoring with correct namespace. *thanks Daniel Reichert*
*   Fixed file path to adhere to fog mainline. *thanks Daniel Reichert*
*   Fixing namespace transition issue. *thanks Daniel Reichert*
*   Adding monitoring tests and their required changes. *thanks Daniel Reichert*
*   Now catching errors correctly, all tests succeed. *thanks Daniel Reichert*
*   Catching errors correctly, all tests succeed. *thanks Daniel Reichert*
*   Adding progress on check tests. *thanks Daniel Reichert*
*   Cleaned up tests, removed ternary operators. *thanks Daniel Reichert*
*   Check tests now working, dns info required to run. *thanks Daniel Reichert*
*   Switched check from dns to http remote request. *thanks Daniel Reichert*
*   Added list tests, helper formats. Cleaned check_tests. *thanks Daniel Reichert*
*   Consolidated list tests, added alarm tests. *thanks Daniel Reichert*
*   Added alarm list and alarm get tests. *thanks Daniel Reichert*
*   Removed unneeded testing group. *thanks Daniel Reichert*
*   Adding alarm example list, get, and evaluate tests. *thanks Daniel Reichert*
*   Adding agent tests. *thanks Daniel Reichert*
*   Adding list data points tests. *thanks Daniel Reichert*
*   Removed redundant test from comments. *thanks Daniel Reichert*
*   Added rackspace monitoring with correct namespace. *thanks Daniel Reichert*
*   Fixed file path to adhere to fog mainline. *thanks Daniel Reichert*
*   Fixing namespace transition issue. *thanks Daniel Reichert*
*   Adding monitoring tests and their required changes. *thanks Daniel Reichert*
*   Now catching errors correctly, all tests succeed. *thanks Daniel Reichert*
*   Catching errors correctly, all tests succeed. *thanks Daniel Reichert*
*   Adding progress on check tests. *thanks Daniel Reichert*
*   Cleaned up tests, removed ternary operators. *thanks Daniel Reichert*
*   Check tests now working, dns info required to run. *thanks Daniel Reichert*
*   Switched check from dns to http remote request. *thanks Daniel Reichert*
*   Added list tests, helper formats. Cleaned check_tests. *thanks Daniel Reichert*
*   Consolidated list tests, added alarm tests. *thanks Daniel Reichert*
*   Added alarm list and alarm get tests. *thanks Daniel Reichert*
*   Removed unneeded testing group. *thanks Daniel Reichert*
*   Adding alarm example list, get, and evaluate tests. *thanks Daniel Reichert*
*   Adding delete agent token coverage of api. *thanks Daniel Reichert*
*   Adding test coverage of deleting agent tokens. *thanks Daniel Reichert*
*   Re-adding tests from rebase. *thanks Daniel Reichert*
*   Adding alarm delete coverage of API. *thanks Daniel Reichert*
*   Adding alarm delete test coverage. *thanks Daniel Reichert*
*   Forgot to add underscore for test groups. *thanks Daniel Reichert*
*   Removing bad Failure test. *thanks Daniel Reichert*
*   WIP:  Adding get tests for checks. *thanks Daniel Reichert*
*   Completed: get_check tests now working. *thanks Daniel Reichert*
*   Completed: get_entity tests implemented and passing. *thanks Daniel Reichert*
*   Removing list_entites failure test. *thanks Daniel Reichert*
*   forgot to return test group to original value. *thanks Daniel Reichert*
*   Removing test group. *thanks Daniel Reichert*
*   add support for openstack network quota endpoints. *thanks Evan Petrie*
*   fixes #1434 : How to use vcloud fog services. *thanks Garima Singh*
*   Fixed an uninitialized constant error. *thanks Hongbin Lu*
*   Add request/parser for DescribeOperableDBInstanceOptions. *thanks James Bence*
*   Return boolean, not index of match. *thanks James Bence*
*   Add model, collection for instance_options. *thanks James Bence*
*   Use correct filters in RDS model instance_options 'all' method. *thanks James Bence*
*   Set up tests (and make them pass) for orderable_db_instance_options. *thanks James Bence*
*   Adjust number of items returned for test. *thanks James Bence*
*   Remove failure test; non-existent engine sometimes has options. *thanks James Bence*
*   add(rackspace monitoring): list notification plans. *thanks Jay Faulkner*
*   test(rackspace_monitoring): Add specific test group. *thanks Jay Faulkner*
*   tests(list_notification_plans): Added basic tests. *thanks Jay Faulkner*
*   fix(tests): ArgumentError + NoMethodError are const. *thanks Jay Faulkner*
*   migrate(auth -> v2): Authenticate via 2.0 API. *thanks Jay Faulkner*
*   fix(alarm_tests): Use npTechnicalContactsEmail. *thanks Jay Faulkner*
*   add(rackspace monitoring): list notification plans. *thanks Jay Faulkner*
*   test(rackspace_monitoring): Add specific test group. *thanks Jay Faulkner*
*   tests(list_notification_plans): Added basic tests. *thanks Jay Faulkner*
*   fix(tests): ArgumentError + NoMethodError are const. *thanks Jay Faulkner*
*   migrate(auth -> v2): Authenticate via 2.0 API. *thanks Jay Faulkner*
*   add(notice): Direct future developers to old repo. *thanks Jay Faulkner*
*   fix for token timeout on cdn. *thanks Jon Holt*
*   Tests for reauthentication in CDN. *thanks Jon Holt*
*   Allow to configure server#scp and server#ssh on the instance level. *thanks Jonas Pfenniger*
*   Fixes issue where Net::SSH would only use the "password" authentication method. *thanks Jonas Pfenniger*
*   add support for m3.xlarge and m3.2xlarge instance flavors. *thanks Kevin McFadden*
*   removing coveralls support for Ruby 1.9.2 in hopes of fixing #1921. *thanks Kyle Rames*
*   removing coveralls support for Ruby 1.9.2 in hopes of fixing #1921 take two. *thanks Kyle Rames*
*   try 3 in removing coveralls for ruby 1.9.2. *thanks Kyle Rames*
*   trying to disable coveralls. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   updating monitoring service to recognize rackspace_region. *thanks Kyle Rames*
*   trying one more times to disable coveralls on 1.9.2. *thanks Kyle Rames*
*   Adds light documentation for GCE and GCS. *thanks Nat Welch*
*   A set of smoke tests for GCE. *thanks Nat Welch*
*   fix some small bugs in the gce smoke tests. *thanks Nat Welch*
*   some more small bugs in the GCE examples. *thanks Nat Welch*
*   Be alittle more specific in the footer of Google Readme. *thanks Nat Welch*
*   Make public_url function easier to read and change acl request to deal with nokogiri changes. *thanks Nat Welch*
*   Examples tweak. *thanks Nat Welch*
*   remove networks. *thanks Nat Welch*
*   Fix some issues with GCE examples and disk requests. *thanks Nat Welch*
*   Fix comments in Google snapshot example. *thanks Nat Welch*
*   Renamed Fog::AWS::SES::Real#verify_domain to #verify_domain_identity. *thanks Postmodern*
*   Fix all in Fog::Compute::Servers. *thanks Romain Vrignaud*
*   Fix Fog::Compute::Google::Flavor all method. *thanks Romain Vrignaud*
*   Add a parameter to servers.all for rackspace v2 to make it the same as other providers. *thanks Sam Kottler*
*   Remove whitespace from the Rackspace V2 test. *thanks Sam Kottler*
*   Fix #server so that it returns the right server instead of all servers. *thanks Shay Bergmann*
*   Changing the non-ascii dash in the url. *thanks Steve Frank*
*   use params instead of prep. *thanks Thomas Cate*
*   Add VPC security groups to the RDS instances. *thanks Timur Alperovich*
*   [aws|rds]: PubliclyAccessible is boolean. *thanks Timur Alperovich*
*   remove dependency on active_support's present? method. *thanks Toby Hede*
*   Cleanup and refactor digitalocean integration. *thanks Trae Robrock*
*   Whitespace. *thanks Trae Robrock*
*   Whitespace, fix tests for running in non mock mode, and clean up in non mock mode. *thanks Trae Robrock*
*   digitalocean supports bootstrap. *thanks Trae Robrock*
*   Fix digitalocean server test. *thanks Trae Robrock*
*   Add digitalocean mock key to run these tests on travis. *thanks Trae Robrock*
*   Add ip_address to the mock. *thanks Trae Robrock*
*   Remove mock server from servers list on destroy. *thanks Trae Robrock*
*   Adding exception from net-ssh 2.6 that occurs during bootstrap as sshd is just starting up. *thanks Trae Robrock*
*   Add mock for dnsimple and fix tests for non mock mode. *thanks Trae Robrock*
*   Add mock and test for get_record. *thanks Trae Robrock*
*   Correct record creation response. *thanks Trae Robrock*
*   Return a 404 if the domain does no exist. *thanks Trae Robrock*
*   Add proper error message to 404. *thanks Trae Robrock*
*   handle zone with no records. *thanks Trae Robrock*
*   Handle missing record case. *thanks Trae Robrock*
*   Use the zone id for record creation. *thanks Trae Robrock*
*   Fix mock for creation by id. *thanks Trae Robrock*
*   Use the id for deletion also. *thanks Trae Robrock*
*   Use id for record update. *thanks Trae Robrock*
*   Add ip_address method back, but deprecate it. *thanks Trae Robrock*
*   Allow v1 auth for OpenStack. *thanks Yauheni Kryudziuk*
*   fix inner/outer variable shadowing. *thanks geemus*
*   random ip address support. *thanks mlincoln*
*   lib/fog/cloudstack/models/compute/servers.rb must check for nil before checking for empty. *thanks torake.fransson*

#### [openstack|compute]
*   update volume tests. *thanks Brian D. Burns*
*   update flavor tests. *thanks Brian D. Burns*

#### [openstack|image]
*   strip unused headers in #update_image. *thanks Brian D. Burns*

#### [openstack|storage]
*   put_object with request_block can not be idempotent. *thanks Brian D. Burns*
*   added the ability to upload files using blocks in the same manner as the Rackspace provider. *thanks Kyle Rames*
*   updating object tests to support ruby 1.8.7. *thanks Kyle Rames*
*   Added temporary signed URL support. *thanks Yauheni Kryudziuk*

#### [rackspace]
*   refined authentication endpoint tests. *thanks Kyle Rames*
*   updated exceptions to include the service transaction id if available. *thanks Kyle Rames*
*   added transaction id to monitoring exceptions; passing service into slurp for compute, databases, dns and load balancers. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*

#### [rackspace|compute_v2]
*   renaming keypairs to key_pairs to match other compute implementations. *thanks Kyle Rames*

#### [rackspace|identity]
*   added error handling to make service catalog more robust. *thanks Kyle Rames*
*   fixing broken service catalog test. *thanks Kyle Rames*

#### [rackspace|monitoring]
*   WIP initial commit of alarm example tests. *thanks Daniel Reichert*
*   Adding alarm examples tests. *thanks Daniel Reichert*
*   Adding alarm example tests. *thanks Daniel Reichert*
*   WIP Initial commit of alarm tests. *thanks Daniel Reichert*
*   Adding alarm example(s) tests. *thanks Daniel Reichert*
*   Adding working alarm tests. *thanks Daniel Reichert*
*   Adding support required for tests to pass. *thanks Daniel Reichert*
*   Correcting entity destroy logic. *thanks Daniel Reichert*
*   Fixing entity destroy logic. *thanks Daniel Reichert*
*   Addding Alarms and Check-Types tests. *thanks Daniel Reichert*
*   Adding mocks pending indication. *thanks Daniel Reichert*
*   Update Alarm bug fixed, uncommenting test. *thanks Daniel Reichert*
*   updating to re-authenticate token on expiration; adding monitoring authentication tests. *thanks Kyle Rames*
*   updating to use fog conventions. *thanks Kyle Rames*
*   adding model tests for agent_token, check, and entity; added destroy method to agent_token and check models; updated models to retrieve identity from header value 'X-Object-ID'; updated check model to take an entity object or id. *thanks Kyle Rames*
*   removing bad test per `@irdan.` *thanks Kyle Rames*
*   adding model tests for metrics and data points. *thanks Kyle Rames*
*   updated monitoring tests to skip sleeping if we are running in mocked mode. *thanks Kyle Rames*
*   fixing broken monitoring test. *thanks Kyle Rames*
*   replaced entity_id and check_id attributes with entity and check attributes; removed entity_id from base module. *thanks Kyle Rames*

#### [rackspace|storage]
*   put_object with request_block can not be idempotent. *thanks Brian D. Burns*

#### [vsphere]
*   Raise NotFound exception when Datacenter or Template is not found. *thanks Carlos Sanchez*
*   Make mock data consistent across operations. *thanks Carlos Sanchez*
*   searchIndex.FindByUuid datacenter parameter must be a RbVmomi::VIM::Datacenter. *thanks Carlos Sanchez*
*   Need to turn off vm and wait until off before destroying. *thanks Carlos Sanchez*
*   Fix NoMethodError: undefined method in list_virtual_machines. *thanks Carlos Sanchez*

#### [xenserver]
*   Added support to get VM by uuid. *thanks Celso Fernandes*
*   Console model created. *thanks Gustavo Villalta*
*   Consoles collection created. *thanks Gustavo Villalta*


## 1.14.0 07/19/2013
*Hash* b9f1659ebd45c84db011c71b53cc581a1b7ac7e1

Statistic     | Value
------------- | --------:
Collaborators | 49
Downloads     | 2713501
Forks         | 860
Open Issues   | 155
Watchers      | 2634

**MVP!** Erik Michaels-Ober

#### [misc]
*   Create separate Gemfile for Ruby 1.8.7. *thanks Erik Michaels-Ober*
*   Update nokogiri dependency to version ~>1.5. *thanks Erik Michaels-Ober*
*   Add note about installing on Ruby 1.8.7 [ci skip]. *thanks Erik Michaels-Ober*
*   add coveralls to Gemfile.1.8.7. *thanks geemus*


## 1.13.0 07/19/2013
*Hash* 7f5b0b4931d8fe85596f67013ef285fd0b8335e0

Statistic     | Value
------------- | --------:
Collaborators | 49
Downloads     | 2712905
Forks         | 860
Open Issues   | 157
Watchers      | 2634

**MVP!** James Bence

#### [AWS | AutoScaling]
*   Do not send Instances for update_auto_scaling_group     (Avoids 413 Request Entity Too Large for ASGs with lots of instances). *thanks Michael Hale*

#### [AWS | Autoscaling]
*   whitelist the options for update_auto_scaling_group. *thanks Michael Hale*
*   whitelist the options for create_auto_scaling_group. *thanks Michael Hale*
*   dry up expected options. *thanks Michael Hale*
*   correct whitelist for create_auto_scaling_group. *thanks Michael Hale*
*   ensure tests work in 1.8.7. *thanks Michael Hale*

#### [Brightbox]
*   Updates to add collaborations. *thanks Hemant Kumar*
*   Extract Compute::Shared to own file. *thanks Paul Thornthwaite*

#### [Openstack|Volumes]
*   alias type to volume_type. *thanks Grzesiek Kolodziejczyk*

#### [Openstack|volume]
*   Add #get to volumes collection. *thanks Grzesiek Kolodziejczyk*
*   fix key name for volume_type. *thanks Grzesiek Kolodziejczyk*
*   create volumes from other vol. *thanks Grzesiek Kolodziejczyk*

#### [aws|storage]
*   parse #complete_multipart error. *thanks Brian D. Burns*

#### [aws|sts]
*   Add support for the AssumeRole STS method.  Also enable the ability for the STS               service to use IAM profiles to grab credentials off the EC2 instance, as is in place               for the other AWS services. *thanks Caleb Tennis*

#### [cli]
*   Changes `fog --version` short option to `-v`. *thanks Paul Thornthwaite*

#### [core]
*   Removes unused getting of Constant. *thanks Paul Thornthwaite*
*   Comments why Nokogiri 1.6 is not being used. *thanks Paul Thornthwaite*
*   Move XML/JSON code up out of core. *thanks Paul Thornthwaite*
*   Fog::Connection documentation. *thanks Paul Thornthwaite*
*   Adds initial Fog::Connection tests. *thanks Paul Thornthwaite*
*   Test Core version not deprecated one. *thanks Paul Thornthwaite*

#### [core/xml]
*   Splits SAX parsing from Connection. *thanks Paul Thornthwaite*

#### [digitalocean]
*   Rename do to docean in examples. *thanks Ørjan Blom*

#### [fix]
*   Corrected the service mocks for testing to respond with a 304 to values of If-Modified-Since that match Last-Modified. *thanks Bob Lail and Luke Booth*

#### [google|compute]
*   Change default image to most recent version of wheezy. *thanks Nat Welch*
*   Fix some bugs with using create without bootstrap. *thanks Nat Welch*

#### [misc]
*   Add PubliclyAccessible option to RDS. *thanks Adam Tucker*
*   Extend capability to restore_db_instance_from_db_snapshot. *thanks Adam Tucker*
*   Signature method requires x-amz-security-token header. *thanks Adam Tucker*
*   Infer the 'image' URL correctly when inserting a server. *thanks Akshay Moghe*
*   increased iops limit to 4000. http://aws.typepad.com/aws/2013/05/provision-up-to-4k-iops-per-ebs-volume.html. *thanks Angelo Marletta*
*   Added support for [xenserver] snapshot. *thanks Celso Fernandes*
*   Fixes security group handling for spot requests launching into a VPC on AWS. *thanks Dave Myron*
*   Swapped to SecurityGroupId. *thanks Dave Myron*
*   fix create_tenant Mock response description and name. *thanks Doug McInnes*
*   Update excon dependency to version ~>0.24.0. *thanks Erik Michaels-Ober*
*   Update excon dependency to version ~>0.25.0. *thanks Erik Michaels-Ober*
*   Passing the connection_options parameter to underlying Fog::Storage object. *thanks Hector Castro*
*   Passing the connection_options parameter to underlying Fog::Storage object     for Fog::RiakCS::Provisioning. *thanks Hector Castro*
*   Used publicURL as default endpoint type for OpenStack network. *thanks Hongbin Lu*
*   Rename 'each' method to 'each_page'. *thanks James Bence*
*   Loop over Marker header in 'all', remove 'each'. *thanks James Bence*
*   Inspect error.response.body, not error.message. *thanks James Bence*
*   Restore implementation of each/all. *thanks James Bence*
*   Refactor error handling. *thanks James Bence*
*   Remove code from other branch-in-progress. *thanks James Bence*
*   Remove mistaken version update. *thanks James Bence*
*   Construct hash with => (for 1.8.7). *thanks James Bence*
*   Use specific error classes, not generic Fog::Compute::AWS::Error. *thanks James Bence*
*   Add describe_db_log_files request for AWS, version 2013-05-15. *thanks James Bence*
*   Add 'each' that iterates over all log files. *thanks James Bence*
*   Add parser/request for DownloadDBLogFilePortion. *thanks James Bence*
*   Use correct filters on RDS model snapshots 'all' method. *thanks James Bence*
*   Use correct filters in RDS model logfiles 'all' method. *thanks James Bence*
*   More DRY, succinct implementation of tag parsing. *thanks James Bence*
*   Remove extraneous nil. *thanks James Bence*
*   Add db identifier to parser, use it for log_file model. *thanks James Bence*
*   Get partial log content via method call; add to log_file model attributes. *thanks James Bence*
*   adding proper fixed secondary_ip support. *thanks John E. Vincent*
*   remove a debug entry. *thanks John E. Vincent*
*   Allows to set the account meta key by setting hp_account_meta_key, needed to generate temp urls using the HP provider, explicitly, instead of using hp_secret_key. If hp_account_meta_key is not given hp_secret_key is used as hp_account_meta_key. *thanks Julian Fischer*
*   HP uses a different strategy to create the signature that is passed to swift than OpenStack.  As the HP provider is broadly used by OpenStack users the OpenStack strategy is applied when the `@hp_account_meta_key` is given. *thanks Julian Fischer*
*   Adds Fog::Storage::HP::File#url method to enable compatibility with Fog::Storage::AWS::File. *thanks Julian Fischer*
*   Fixed bug undefined local variable or method account_meta_key. *thanks Julian Fischer*
*   Bugfix: `@hp_secret_key` instead of `@hp_account_meta_key` required in storage.rb:186. *thanks Julian Fischer*
*   Avoids Digest::HMAC.hexdigest to remain 1.8.7 compatibility. *thanks Julian Fischer*
*   Remove File#url. *thanks Julian Fischer*
*   Renames hp_account_meta_key to os_account_meta_temp_url_key. *thanks Julian Fischer*
*   merging with master. *thanks Kyle Rames*
*   Add nil check on metadata mock. *thanks Mike Moore*
*   Add attachment check to detach_volume mock. *thanks Mike Moore*
*   Add array coalesce. *thanks Mike Moore*
*   Uping version to v1beta15. *thanks Nat Welch*
*   trying to fix sshable? for gce. *thanks Nat Welch*
*   more attempts to get ssh in compute workings. *thanks Nat Welch*
*   temporary debug info. *thanks Nat Welch*
*   Better comments and a logging attempt. *thanks Nat Welch*
*   bug in network interfaces code. *thanks Nat Welch*
*   Trying to be more consistent in code. Removing logging. *thanks Nat Welch*
*   trying to get metadata do one request per access. *thanks Nat Welch*
*   Forgot to delete two lines. *thanks Nat Welch*
*   correct syntax for the metadata craziness. *thanks Nat Welch*
*   I'm an idiot. *thanks Nat Welch*
*   trying again to get metadata working... *thanks Nat Welch*
*   Hashes not Arrays. *thanks Nat Welch*
*   ahh machine api changed as well... gotta figure out what the api is returning now. *thanks Nat Welch*
*   can't be private. *thanks Nat Welch*
*   whoops. *thanks Nat Welch*
*   Nope. *thanks Nat Welch*
*   not that either. *thanks Nat Welch*
*   so many syntax errors. *thanks Nat Welch*
*   in v15, there are all kinds of places images can hide. *thanks Nat Welch*
*   make sure I'm getting valid data back. *thanks Nat Welch*
*   trying to actually handle response error data. *thanks Nat Welch*
*   just the message. *thanks Nat Welch*
*   aha! This could be the issue. *thanks Nat Welch*
*   why isn't image_url getting set?. *thanks Nat Welch*
*   nil, not empty. *thanks Nat Welch*
*   try this... *thanks Nat Welch*
*   never being written. *thanks Nat Welch*
*   trying to use correct code location. *thanks Nat Welch*
*   alright! Insertion!. *thanks Nat Welch*
*   Why is this request failing. *thanks Nat Welch*
*   Send the right zone. *thanks Nat Welch*
*   zone looks to be bad in get_server. *thanks Nat Welch*
*   why!. *thanks Nat Welch*
*   this is probably not stable. *thanks Nat Welch*
*   Different trypes of input. *thanks Nat Welch*
*   modify all of the things. *thanks Nat Welch*
*   passing around teh data. *thanks Nat Welch*
*   better zone name. *thanks Nat Welch*
*   sshable? shouldn't just die. *thanks Nat Welch*
*   inifite loop get. *thanks Nat Welch*
*   more bad status code checks. *thanks Nat Welch*
*   init response. *thanks Nat Welch*
*   trying to figure out what's wrong. *thanks Nat Welch*
*   Patch from a fellow googler. *thanks Nat Welch*
*   Switch running? back to ready?. *thanks Nat Welch*
*   network_interfaces can be nil. *thanks Nat Welch*
*   Default to running user for username. *thanks Nat Welch*
*   A patch from a fellow googler. *thanks Nat Welch*
*   metadata could be nil. *thanks Nat Welch*
*   Throw errors instead of printing them. *thanks Nat Welch*
*   refactor image lookup code. *thanks Nat Welch*
*   Let's wait till sshable. *thanks Nat Welch*
*   whoops. *thanks Nat Welch*
*   small style tweaks for #1946. *thanks Nat Welch*
*   Added option parsing to bin/fog. *thanks Postmodern*
*   Added the -f, --fogrc option for specifying an alternate fogrc file. *thanks Postmodern*
*   Renamed -f,--fogrc to -C,--credentials-path. *thanks Postmodern*
*   Added Fog::AWS::SES.verify_domain_identity. *thanks Postmodern*
*   Fixed description for the #verify_domain_identity tests. *thanks Postmodern*
*   Actually call verify_domain_identity. *thanks Postmodern*
*   Add basic error handling for Fog::AWS::SES. *thanks Postmodern*
*   Convert the raw_message for send_raw_email, just in case. *thanks Postmodern*
*   Raise Fog::AWS::SES::InvalidParameterError for InvalidParameterValue. *thanks Postmodern*
*   Fix autoincrement when creating a flavor if private flavors exist. *thanks Thomas Kadauke*
*   Add RDS API version parameter option. *thanks Timur Alperovich*
*   Initial documentation for using Fog with CloudSigma. *thanks Viktor Petersson*
*   Fixed typos. *thanks Viktor Petersson*
*   add license to gempsec. *thanks geemus*
*   Added Disk and Disks to Google compute. Created new insert server request method that is backward compatible with the old request method, but also allows all insert server options to be used rather than a subset. *thanks jordangbull*
*   cleaned out print statements. Refactored disk(s) to be created the same way as other models. Fixed wait_for on disks to properly work. *thanks jordangbull*
*   Fixed minor import issue. *thanks jordangbull*
*   Rebased and cleaned up google fog. Changed insert_server to allow all options (not backwards compatible, but throws an informative error. *thanks jordangbull*
*   Cleaned code and fixed issue with getting a resource too soon after request for creation. *thanks jordangbull*
*   Added access configs name so public ip can be retrieved. *thanks jordangbull*
*   Fixed bug with bootstrapped servers not being sshable. *thanks jordangbull*
*   small fix in metadata for servers. *thanks jordangbull*
*   Fixed server bootstrap to remove default image if a boot disk is specified. *thanks jordangbull*
*   Google Cloud Compute now raises Errors rather than throwing them. *thanks jordangbull*
*   Added destroy method to disk and zone method. *thanks jordangbull*
*   Add SimpleCov and Coveralls.io dependenices     Add rake tasks for travis, which include publishing coverage reports. *thanks mlincoln*
*   Change travis to use a rake task instead of shindont directly.     This is partly necessary for     https://github.com/lemurheavy/coveralls-ruby/pull/20, though     I'm a fan of running just "rake" or "rake travis" for simplicity     anyways. *thanks mlincoln*
*   The actual simplecov/coveralls setup.     The use of Process.pid is an attempt to avoid confusing SimpleCov when     running tests in parallel.  Other tests frameworks take a similar     approach when they detect parallel_tests. *thanks mlincoln*
*   Some cleanup based on comments on the PR. *thanks mlincoln*

#### [openstack|compute]
*   support block_device_mapping. *thanks Grzesiek Kolodziejczyk*

#### [openstack|image]
*   Fix image reload. *thanks Ferran Rodenas*

#### [openstack|metering]
*   Allow multiple filtering queries. *thanks Alvin Garcia*
*   Fix get_statistics mock. *thanks Alvin Garcia*
*   Added metering service for Ceilometer. *thanks Philip Mark M. Deazeta*

#### [openstack|volume]
*   support imageRef option. *thanks Grzesiek Kolodziejczyk*

#### [openvz]
*   Fixes #1871 test helper callback. *thanks Paul Thornthwaite*

#### [rackspace]
*   fix JSON error parsing. *thanks Brian D. Burns*
*   updated services to re-authenticate when authentication token expires. *thanks Kyle Rames*
*   adding block and parse_json parameters to request parameter calls. *thanks Kyle Rames*
*   fixing broken user tests; adding wait_for_request method to add in testing. *thanks Kyle Rames*
*   setting default fog timeout to 2000 for testing; removing specific hard coded timeouts. *thanks Kyle Rames*

#### [rackspace|block_storage]
*   fixing broken volume type tests. *thanks Kyle Rames*

#### [rackspace|cdn]
*   updating cdn to throw exceptions from storage namespace rather than cdn. This was done for historical reasons. *thanks Kyle Rames*

#### [rackspace|compute]
*   updating mocks. *thanks Kyle Rames*
*   fixing broken address test. *thanks Kyle Rames*
*   fixed metadata tests. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   adding parameter to save method in order to make it more polymorphic. *thanks Kyle Rames*

#### [rackspace|dns]
*   fixing DNS pagination issue #1887. *thanks Kyle Rames*
*   added total_entries attribute to zones. *thanks Kyle Rames*
*   adding :limit => 100 to clarify that all returns a limit of 100 records per page at `@rupakg` suggestion. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*

#### [rackspace|identity]
*   fixing broken identity tests. *thanks Kyle Rames*

#### [rackspace|load balancers]
*   making failing usage tests cases pending until I can get them fixed. *thanks Kyle Rames*

#### [rackspace|storage]
*   add methods for SLO support. *thanks Brian D. Burns*
*   add #put_dynamic_obj_manifest. *thanks Brian D. Burns*
*   patch #delete_static_large_object for Swift v1.8. *thanks Brian D. Burns*
*   fix tests under ruby-1.8.7. *thanks Brian D. Burns*
*   add #delete_multiple_objects. *thanks Brian D. Burns*
*   patch #delete_multiple_objects for Swift v1.8. *thanks Brian D. Burns*
*   update File model to submit etags if they are specified. *thanks Kyle Rames*

#### [rackspce|block_storage]
*   fixing tests. *thanks Kyle Rames*

#### [vcloud|compute]
*   better defaults for configuring vm content-type. *thanks geemus*

#### [vsphere]
*   fix regex typo. *thanks Dominic Cleal*

#### [xenserver|compute]
*   Small fix for snapshot tests added in #1914. *thanks Sergio Rubio*


## 1.12.1 06/11/2013
*Hash* 8663e9079edb69f1a56ea887379f94e6d5efd0d8

Statistic     | Value
------------- | --------:
Collaborators | 49
Downloads     | 2417193
Forks         | 817
Open Issues   | 150
Watchers      | 2564

**MVP!** Hongbin Lu

#### [misc]
*   Don't parse non-JSON response. *thanks Hongbin Lu*
*   turn verbose error responses on. *thanks geemus*


## 1.12.0 06/11/2013
*Hash* 2dd2a8b003fd7ee89141820e0d3c7ff161e74f60

Statistic     | Value
------------- | --------:
Collaborators | 49
Downloads     | 2416827
Forks         | 817
Open Issues   | 153
Watchers      | 2563

#### [AWS]
*   adds 'hypervisor', 'lifecycle', 'requester_id', 'source_dest_check', 'spot_instance_request_id', 'virtualization_type' attributes to instances, also fixes instance tests to work in non-mocking mode. *thanks Eric Stonfer*

#### [AWS | Compute]
*   Added copy_image request with parser, mocks and tests. *thanks Rad Gruchalski*

#### [AWS|IAM]
*   Added AWS IAM iam.roles support. *thanks Rad Gruchalski*

#### [AWS|RDS]
*   Properly rescue NotFound exceptions. *thanks Aaron Suggs*

#### [Brightbox]
*   Expose expires_in value for the access token. *thanks Amitava*
*   Rename old destroy requests to delete. *thanks Paul Thornthwaite*
*   Documentation fixes. *thanks Paul Thornthwaite*

#### [Rackspace|Storage]
*   updating large file upload based on `@burns` suggestions. *thanks Kyle Rames*

#### [Zerigo|DNS]
*   Remove default 3600 TTL. *thanks Eric Hankins*

#### [cloudsigma]
*   Add CloudSigma compute provider. *thanks Kaloyan Kanev*
*   Fix create request not expecting status 201. *thanks Kaloyan Kanev*
*   Make api location as an option (:cloudsigma_host). *thanks Kaloyan Kanev*
*   Fix excon HTTPStatusError#response not having []= and failing on assignment of json decoded body. *thanks Kaloyan Kanev*

#### [cloudstack]
*   fix broken mock test. *thanks geemus*

#### [dynect]
*   remove should usage in tests. *thanks geemus*

#### [misc]
*   Add joyent API version and network support GH-1853. *thanks Blake Irvin and Eric Saxby*
*   Add post_object_restore support. *thanks Bradley Schaefer*
*   Fix excon expects syntax for post object restore. *thanks Bradley Schaefer*
*   Add 409 (Conflict) as an expected restore response. *thanks Bradley Schaefer*
*   Very basic mock for post_object_restore. *thanks Bradley Schaefer*
*   debug excon errors in tests. *thanks Brian D. Burns*
*   Include the ResourceRecordSetCount. *thanks Edward Muller*
*   Support pagination on Zerigo DNS zones. *thanks Eric Hankins*
*   Simplify Zerigo DNS list_zones request. *thanks Eric Hankins*
*   Update docs for Zerigo DNS list_zones request. *thanks Eric Hankins*
*   Add TTL on save rather than initialize. *thanks Eric Hankins*
*   Add Config attributes, and the "get" method for Configs to get detail of a specific config object. *thanks Eric Wong*
*   Revert "Updated gem spec to require json rather than multi_json". *thanks Erik Michaels-Ober*
*   proper user creation in OS create_server mock. *thanks Evan Petrie*
*   Remove spurious warning... *thanks Frederic Jean*
*   Fixed typo. *thanks Geoff Pado*
*   Add :id attribute to libvirt nic model. *thanks Greg Sutcliffe*
*   Include all snapshots in FOG::AWS::RDS::Snapshots#all. *thanks Harry Wilkinson*
*   Add Snaphost#each method with lazy pagination. *thanks Harry Wilkinson*
*   Added support for OpenStack region for network service. *thanks Hongbin Lu*
*   Adding support for AWS CloudFormation list_stacks and list_stack_resources API calls. *thanks Joe Kinsella*
*   Using AWS::Compute::Error for CloudFormation errors produces erroneous error messages. *thanks Joe Kinsella*
*   Support both RSpec 1.x and 2.x. *thanks Josef Stribny*
*   Chdir in a block to dry up all method. *thanks Karl Freeman*
*   Fixes #39 joyent server resize command requires expected response code. *thanks Kevin Chan*
*   Fixes #1822 Joyent list_machines is slower than it needs to be. *thanks Kevin Chan*
*   Support for request signing via ssh-agent. *thanks Kevin Chan*
*   Fixes for tags for pre7 api, more ssh-agent improvements Refs: kevinykchan/knife-joyent#37. *thanks Kevin Chan*
*   GH-1853 "public" attribute for network. *thanks Kevin Chan*
*   Fix "cache_controle" typo in docs. *thanks Mark Rushakoff*
*   Avoids Fog::Compute::Joyent::Real#decode_time_attrs raising an exception when an empty string is returned as created or updated property. *thanks Pablo Baños López*
*   server.tags implemented. *thanks Rodrigo Estebanez*
*   Tag#destroy implemented. *thanks Rodrigo Estebanez*
*   Tags#create implemented. *thanks Rodrigo Estebanez*
*   shows customizationScript of a VM. *thanks Rodrigo Estebanez*
*   VM`@customization_script=.` *thanks Rodrigo Estebanez*
*   escapeHTML. *thanks Rodrigo Estebanez*
*   server.tags implemented. *thanks Rodrigo Estebanez*
*   Tag#destroy implemented. *thanks Rodrigo Estebanez*
*   Tags#create implemented. *thanks Rodrigo Estebanez*
*   shows customizationScript of a VM. *thanks Rodrigo Estebanez*
*   VM`@customization_script=.` *thanks Rodrigo Estebanez*
*   escapeHTML. *thanks Rodrigo Estebanez*
*   Whitespace. *thanks Sean Handley*
*   Options get formed into the body. *thanks Sean Handley*
*   Don't delete the options if they were never there!. *thanks Sean Handley*
*   Allow creation with objects. *thanks Sean Handley*
*   This withstands naming/renaming issues. *thanks Sean Handley*
*   quote data in regex. *thanks Simon Josi*
*   Add API calls to manage flavor access across tenants. *thanks Thomas Kadauke*
*   fail when cloudstack default view empty. *thanks Tor-Ake Fransson*
*   fix broken test related to redacted excon error bodies. *thanks geemus*
*   Don't CGI encode header query values in the signature string. *thanks ronen barzel*
*   Consolidation suggested by Wesley Beary. *thanks torake.fransson*
*   servers can still be nil under some circumstances (server id specified does no longer exist). *thanks torake.fransson*

#### [openstack|compute]
*   Add mock method to list_address_pools. *thanks Ferran Rodenas*

#### [openstack|image]
*   Define get method for images. *thanks Ferran Rodenas*

#### [openstack|network]
*   Add support for OpenStack Networking LBaaS extension. *thanks Ferran Rodenas*

#### [openstack|storage]
*   allow headers to be specified for object manifest. *thanks Brian D. Burns*

#### [openvz|compute]
*   Initial commit. *thanks Patrick Debois*

#### [rackspace]
*   pass connection_options onto identity service so we can auth behind a proxy. *thanks Kyle Rames*

#### [rackspace|compute]
*   removing erronious note on setup method. *thanks Kyle Rames*

#### [rackspace|lb]
*   Add support for timeout attribute. *thanks Decklin Foster*
*   Use a non-default timeout so we are actually testing if the attribute was set. *thanks Decklin Foster*
*   Pass through timeout option on LB creation (also, we know algorithm works). *thanks Decklin Foster*

#### [rackspace|storage]
*   add large object container and prefix options. *thanks Brian D. Burns*
*   allow headers to be specified for object manifest. *thanks Brian D. Burns*
*   created a last_modified= method in the File class which works around a timezone bug in the swift service. *thanks Kyle Rames*
*   updated put_object to allow blocks to upload large files; added large file upload example and documentation. *thanks Kyle Rames*
*   made large object delete tests pending if mocking is turned on. *thanks Kyle Rames*
*   fixing large upload example and documentation. *thanks Kyle Rames*
*   tweaking upload large file example to use X-Object-Manifest header in anticipation of PR #1855. *thanks Kyle Rames*
*   fixing typo in large file upload documentation; updated large file upload to work with ruby 1.8.7. *thanks Kyle Rames*

#### [stormnondemand|compute]
*   Add Notification APIs. *thanks Eric Wong*

#### [stormondemand]
*   fix service exception handling. *thanks Eric Wong*
*   fix typo bugs and move shared code into shared.rb module. *thanks Eric Wong*
*   fix some minor problems. Add a README.md file to describe how to use the storm on demand APIs. *thanks Eric Wong*

#### [stormondemand|account]
*   Add Account service and token APIs. *thanks Eric Wong*
*   Add Account service to the service lsit. *thanks Eric Wong*

#### [stormondemand|billing]
*   Add Billing service and related APIs. *thanks Eric Wong*

#### [stormondemand|compute]
*   Add API version in requrest path and add new attributes in Config. *thanks Eric Wong*
*   Fix request path. *thanks Eric Wong*
*   Add additional attributes to Image and CRUD methods to Images. *thanks Eric Wong*
*   Move destroy/update/restore methods to image.rb. *thanks Eric Wong*
*   Fix the get parameters. *thanks Eric Wong*
*   Add all LoadBalancer related APIs. *thanks Eric Wong*
*   Add all server APIs. *thanks Eric Wong*
*   Add all template APIs. *thanks Eric Wong*
*   Add stats graph API. *thanks Eric Wong*
*   Add all Private IP APIs. *thanks Eric Wong*
*   Add Network IP APIs. *thanks Eric Wong*
*   Add Firewall APIs. *thanks Eric Wong*
*   Add Firewall Ruleset APIs. *thanks Eric Wong*
*   Add Pool APIs. *thanks Eric Wong*
*   Add Network Zone APIs. *thanks Eric Wong*
*   change all keys for response data into strings. *thanks Eric Wong*
*   Add Product APIs. *thanks Eric Wong*

#### [stormondemand|dns]
*   Add DNS service and domain APIs. *thanks Eric Wong*
*   Add DNS record APIs. *thanks Eric Wong*
*   add record region APIs. *thanks Eric Wong*
*   Add Reverse APIs. *thanks Eric Wong*
*   Add DNS Zone APIs. *thanks Eric Wong*
*   Add DNS Service to StormOnDemand. *thanks Eric Wong*

#### [stormondemand|monitoring]
*   Add a new Monitoring service and add/move load/bandwidth/service APIs. *thanks Eric Wong*

#### [stormondemand|network]
*   Add a new Network service and move all network code in Compute into Network. *thanks Eric Wong*

#### [stormondemand|storage]
*   Add Storage service and cluster API. *thanks Eric Wong*
*   Add Volume APIs. *thanks Eric Wong*

#### [stormondemand|support]
*   Add Support service and APIs for alert and support tickets. *thanks Eric Wong*

#### [stormondemand|vpn]
*   Add new VPN service and APIs. *thanks Eric Wong*


## 1.11.1 05/05/2013
*Hash* 2cfeaf236e4ebcf883d0e17f586293d6cd66f379

Statistic     | Value
------------- | --------:
Collaborators | 47
Downloads     | 2177247
Forks         | 783
Open Issues   | 140
Watchers      | 2494

#### [VSphere]
*   Added VMware customvalue and customfields to read the annotations for each VM. *thanks Marc Grimme*
*   Removed dependency to the Datacenters root path. So that now it should even work with other localizations. *thanks Marc Grimme*

#### [misc]
*   Load google/api_client late to avoid dep. *thanks Dan Prince*
*   Add a custom log warning on load error. *thanks Dan Prince*

#### [vSphere]
*   Refactor and extend network interface methods (similar to the ovirt implementation)     * added methods to add, remove and update interfaces for vSphere     * added missing method to retrieve the interface     * added existing attribute key to interface (required for modifying, deleting interfaces)     * alias interface's mac to id. *thanks Marc Grimme*
*   fixed bug that datastores in subfolders would not be found. *thanks Marc Grimme*


## 1.11.0 05/04/2013
*Hash* bbea0162df01317405bfbb4c427fdde40e5f0f2c

Statistic     | Value
------------- | --------:
Collaborators | 1
Downloads     | 2175484
Forks         |
Open Issues   |
Watchers      |

**MVP!** Nat Welch

#### [Brightbox]
*   Updates image selector for name format. *thanks Paul Thornthwaite*

#### [Docs]
*   Fixes assorted yardoc tagging issues. *thanks Paul Thornthwaite*

#### [aws|iam]
*   user: add created_at attribute. *thanks Pierre Carrier*

#### [cloudstack]
*   add disk_offerings, os_types mock data. *thanks Dmitry Dedov*
*   add list_os_types, list_disk_offerings request mocks. *thanks Dmitry Dedov*
*   list_os_types, list_disk_offerings request tests, rm pending. *thanks Dmitry Dedov*
*   servers collection, add attributes to :all method. *thanks Dmitry Dedov*
*   fix image password_enabled field alias. *thanks Dmitry Dedov*
*   add create_disk_offering request. *thanks Dmitry Dedov*
*   add delete_disk_offering request. *thanks Dmitry Dedov*
*   add disk_offering model. *thanks Dmitry Dedov*
*   add disk_offerings collection. *thanks Dmitry Dedov*
*   add disk offerings to compute, tidy up. *thanks Dmitry Dedov*
*   add create/delete disk_offering mocks. *thanks Dmitry Dedov*
*   add disk_offering model tests. *thanks Dmitry Dedov*
*   fix typo in declaration model. *thanks Dmitry Dedov*
*   add delete_snapshot request mock, fix delete_snapshot description comments. *thanks dm1try*
*   add list_snapshots request mock. *thanks dm1try*
*   add test volume to mock data. *thanks dm1try*
*   tests, add snapshots_attributes to cloudstack provider config. *thanks dm1try*
*   tests, fix snapshot test. *thanks dm1try*
*   tests, remove unreachable code in snapshot test, add testcase for volume relation. *thanks dm1try*

#### [core]
*   fixing brittle json test. *thanks Kyle Rames*

#### [docs::aws::rds]
*   converted formatting from RDoc to YARD. *thanks Weston Platter*

#### [misc]
*   fix case where volume isn't instantly available to attach upon creation. *thanks AltJ*
*   cosmetic - fix space. *thanks Andrew Kuklewicz*
*   fix bug with head request - no query on version id for IA. *thanks Andrew Kuklewicz*
*   Fog::Model#wait_for: eliminate inner retry loop. *thanks Chris Frederick*
*   Implement rescue mode support for Rackspace. *thanks Chris Wuest*
*   Rectify issues with tests and status. *thanks Chris Wuest*
*   OS: Fix revert_resize_server method name. *thanks Dan Prince*
*   Fix non-circular-require warnings. *thanks Eric Hodel*
*   Fix bluebox's Server#public_ip_address. *thanks Eric Lindvall*
*   Fix typo in method name for DynamoDB::Mock#setup_credentials. *thanks James Fraser*
*   (maint) Fixup whitespace. *thanks Jeff McCune*
*   (maint) Clean up whitespace errors. *thanks Jeff McCune*
*   AWS | storage: use #service instead of the deprecated #connection in the tests. *thanks Jonas Pfenniger*
*   AWS | storage: add tests for directory#public_url. *thanks Jonas Pfenniger*
*   AWS | storage: add more uniq_id in the tests to avoid collisions. *thanks Jonas Pfenniger*
*   AWS | storage: disabling broken tests. *thanks Jonas Pfenniger*
*   AWS | storage: make directory.persisted? tell the truth. *thanks Jonas Pfenniger*
*   AWS | storage: fixes ignored location with new buckets. *thanks Jonas Pfenniger*
*   AWS | storage: big refactor. *thanks Jonas Pfenniger*
*   AWS | storage: also escape the bucket name when using the path_style. *thanks Jonas Pfenniger*
*   Updated gem spec to require json rather than multi_json; Fog::JSON will attempt to load and use multi_json first and then fallback to require json; removed hard coded references to multi_json. *thanks Kyle Rames*
*   Adding multi_json to GemFile as it is now an optional dependency for the gem. *thanks Kyle Rames*
*   Added tests for Fog::JSON; Added Fog::JSON::LoadError class; Updated all MultiJson references to Fog::JSON. *thanks Kyle Rames*
*   Added pointers to provider specific documentation to README.md. *thanks Kyle Rames*
*   adding space to force travis to build. *thanks Kyle Rames*
*   Remove the OpenStack API cache busting. *thanks Mark Turner*
*   Changes the path only if subdomain is not `@host.` *thanks Matthieu Huin*
*   Vsphere: add options of numCPUs and memoryMB for VM clone. *thanks Ming Jin*
*   delete vms that is not ready for vm.config, e.g. during the creation period. *thanks Ming Jin*
*   merged fog HEAD, deleting whitespaces. *thanks Ming Jin*
*   delete whitespaces. *thanks Ming Jin*
*   fix issues in checking whether VM is of template type. *thanks Ming Jin*
*   trying to move gce to google. *thanks Nat Welch*
*   more trying to move gce to google. *thanks Nat Welch*
*   GCE -> Google. *thanks Nat Welch*
*   merge bin files. *thanks Nat Welch*
*   google was in the providers twice. *thanks Nat Welch*
*   fixes tests due to class name collision. *thanks Nat Welch*
*   remove more references to gce. *thanks Nat Welch*
*   an attempt to get gce tests working in travis. *thanks Nat Welch*
*   a little sorting of config options. *thanks Nat Welch*
*   trying to move gce to google. *thanks Nat Welch*
*   more trying to move gce to google. *thanks Nat Welch*
*   GCE -> Google. *thanks Nat Welch*
*   merge bin files. *thanks Nat Welch*
*   google was in the providers twice. *thanks Nat Welch*
*   fixes tests due to class name collision. *thanks Nat Welch*
*   remove more references to gce. *thanks Nat Welch*
*   an attempt to get gce tests working in travis. *thanks Nat Welch*
*   a little sorting of config options. *thanks Nat Welch*
*   remove google-api requirements. *thanks Nat Welch*
*   stripping out thin. *thanks Nat Welch*
*   should move auth into a the main class. *thanks Nat Welch*
*   Hopeing the head of the gapi makes things better... *thanks Nat Welch*
*   actually just specify a version. *thanks Nat Welch*
*   load file appropriately. *thanks Nat Welch*
*   fix deprecation notice. *thanks Nat Welch*
*   more attempts to get server creation working. *thanks Nat Welch*
*   get rid of gAPI warnings and Fog deprecation notices. *thanks Nat Welch*
*   successfully launched a server. *thanks Nat Welch*
*   whoops. *thanks Nat Welch*
*   trying to fix 1.8.7. *thanks Nat Welch*
*   still trying to figure out 1.8.7 support. *thanks Nat Welch*
*   fixing another 1.8.7 bug. *thanks Nat Welch*
*   Add correct keys for Google Compute. *thanks Nat Welch*
*   whoops. *thanks Nat Welch*
*   put extra keys in fog credential error. *thanks Nat Welch*
*   Fixes the test running. *thanks Nat Welch*
*   13 is now deprecated. *thanks Nat Welch*
*   An attempt to get disk requests passing tests. *thanks Nat Welch*
*   More accurate disk tests that fail. *thanks Nat Welch*
*   Kernel api has been deprecated. *thanks Nat Welch*
*   removing listoperations as it doesn't exist anymore. *thanks Nat Welch*
*   basis for zone and global operations requests. *thanks Nat Welch*
*   better operation APIs. *thanks Nat Welch*
*   cheating to make operations tests simpler for now. *thanks Nat Welch*
*   firewall tests passing. *thanks Nat Welch*
*   passing zone tests. *thanks Nat Welch*
*   format isn't write, but valid API requests. *thanks Nat Welch*
*   working image test. *thanks Nat Welch*
*   more accurate server requests. *thanks Nat Welch*
*   fix network list test. *thanks Nat Welch*
*   get image tests closer to passing. *thanks Nat Welch*
*   trying to get a simple model test working. *thanks Nat Welch*
*   progress. *thanks Nat Welch*
*   didn't mean to commit this. *thanks Nat Welch*
*   fix server list. *thanks Nat Welch*
*   slightly more accurate image test, although still failing. *thanks Nat Welch*
*   fix delete server. *thanks Nat Welch*
*   Fixes insert and delete. *thanks Nat Welch*
*   Trying to get ssh command working. *thanks Nat Welch*
*   ... really?. *thanks Nat Welch*
*   trying to get ssh to work. *thanks Nat Welch*
*   I'm not saving networkinterfaces. *thanks Nat Welch*
*   more attempts to get ssh working. *thanks Nat Welch*
*   zone_names are urls, but I need to write them as just the name. *thanks Nat Welch*
*   trying to get keys working for ssh. *thanks Nat Welch*
*   auto expand home. *thanks Nat Welch*
*   whoops. *thanks Nat Welch*
*   add set_metadata to upload ssh keys. *thanks Nat Welch*
*   custome sshable. *thanks Nat Welch*
*   reverting bin.rb to original state. *thanks Nat Welch*
*   disable mock running, I think. *thanks Nat Welch*
*   merge fail. *thanks Nat Welch*
*   Fix CHANGELOG fog version for digitalocean, xenserver and openstack. *thanks Sergio Rubio*
*   issue #1275 removed rspec requires - tests pass. *thanks Weston Platter*
*   Adding Google Compute Engine driver. *thanks Ziyad Mir*
*   Updating create server behaviour and defaults. *thanks Ziyad Mir*
*   Adding Google Compute Engine driver. *thanks Ziyad Mir*
*   Updating create server behaviour and defaults. *thanks Ziyad Mir*
*   remove kyle rames from future contention for MVP. *thanks geemus*
*   add trademark notice. *thanks geemus*
*   Revert "add trademark notice". *thanks geemus*
*   add 2.0.0 to travis build list. *thanks geemus*

#### [openstack]
*   Retrieve supported API version for Image & Network services. *thanks Ferran Rodenas*

#### [openstack|compute]
*   Add volume attachment methods. *thanks Ferran Rodenas*
*   Add volume method to server model. *thanks Ferran Rodenas*
*   Add volume tests. *thanks Ferran Rodenas*

#### [openstack|volume]
*   Added quota requests for Cinder. *thanks Philip Mark M. Deazeta*

#### [rackspace]
*   updated NotFound exceptions to include region when available. *thanks Kyle Rames*
*   correcting exception classes on YARD docs. *thanks Kyle Rames*
*   fixing delete image tests. *thanks Kyle Rames*
*   updated ServiceException to catch JSON decoding exception and display a warning message. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   removing duplicate line caused by bad merge. *thanks Kyle Rames*
*   fixing bug with mock data. *thanks Kyle Rames*

#### [rackspace|compute_v2]
*   fixed bug in InvalidStateExceptions. *thanks Kyle Rames*
*   fixed bug where server creation was not adding networks. *thanks Kyle Rames*

#### [rackspace|dns]
*   updated DNS service to use Fog::DNS::Rackspace::NotFound exceptions in keeping with the rest of the services. *thanks Kyle Rames*

#### [rackspace|storage]
*   updated storage and cdn services to wrap excon exceptions in the same manner as the other Rackspace services. *thanks Kyle Rames*

#### [vsphere]
*   Use Fog.mock? as the other providers     Specs can set Fog.mock! without setting the env var. *thanks Carlos Sanchez*
*   Use find_raw_datacenter instead of get_raw_datacenter. *thanks Carlos Sanchez*
*   allow setting ram and num of cpu when cloning. *thanks Mick Pollard*
*   add list_templates function. *thanks Ming Jin*
*   add get_template function. *thanks Ming Jin*

#### [vsphere|compute]
*   Merge tmandke VM list speedups. *thanks Jeff McCune*
*   Add VM template models. *thanks Jeff McCune*
*   fix incorrect filters.merge in networks model. *thanks Mick Pollard*
*   add list_templates function. *thanks Ming Jin*
*   add get_template function. *thanks Ming Jin*
*   add options of numCPUs and memoryMB for VM clone. *thanks Ming Jin*
*   Bulk fetch all managed views VM properties. *thanks Tejas Ravindra Mandke*
*   Switch some attributes to lazyload. *thanks Tejas Ravindra Mandke*


## 1.10.1 04/04/2013
*Hash* a270b69a23b43a8cdab768f88503779f27a74fa0

Statistic     | Value
------------- | --------:
Collaborators | 46
Downloads     | 1993968
Forks         | 746
Open Issues   | 134
Watchers      | 2438

**MVP!** Kyle Rames

#### [VMWare]
*   Fixed broken support for obj_ids with spaces. *thanks Marc Grimme*

#### [Vcloud]
*   Server reset instance vars after save. *thanks dJason*

#### [aws]
*   Handle the "phantom" security group that exists for elbs. *thanks Eugene Howe*
*   mock update_server_certificate. *thanks Josh Lane & Ines Sombra*

#### [aws|beanstalk]
*   Update parser for DescribeEnvironmentResources. *thanks George Scott*

#### [cloudstack]
*   add snapshot model. *thanks Dmitry Dedov*

#### [core]
*   Updated to make ssh timeout user configurable. *thanks Kyle Rames*

#### [digitalocean]
*   Check to see if we have a digital ocean api key before attempting to delete servers. *thanks Kyle Rames*

#### [digitalocean|compute]
*   initial release. *thanks Sergio Rubio*
*   added getting started guide. *thanks Sergio Rubio*
*   Updated server model documentation. *thanks Sergio Rubio*
*   added test helpers. *thanks Sergio Rubio*
*   Implemented Server.reboot. *thanks Sergio Rubio*
*   Implement Server.power_cycle. *thanks Sergio Rubio*
*   tests updates. *thanks Sergio Rubio*
*   Added Servers collection tests. *thanks Sergio Rubio*
*   Implement missing requests. *thanks Sergio Rubio*
*   implemented missing Server actions. *thanks Sergio Rubio*
*   string fixes. *thanks Sergio Rubio*
*   list_servers request test fixes. *thanks Sergio Rubio*
*   server model test fixes. *thanks Sergio Rubio*
*   remove extra comma, breaks ruby 1.8. *thanks Sergio Rubio*
*   Added support to use SSH keys when creating the server. *thanks Sergio Rubio*
*   added some more request. *thanks Sergio Rubio*
*   Added list_flavors mock code. *thanks Sergio Rubio*
*   Added list_images mock code. *thanks Sergio Rubio*
*   added list_servers mock code. *thanks Sergio Rubio*
*   added list_regions mock code. *thanks Sergio Rubio*
*   initialize compute service mock data. *thanks Sergio Rubio*
*   added create_server mock code. *thanks Sergio Rubio*
*   added create_ssh_key mock code. *thanks Sergio Rubio*
*   added destroy_server mock code. *thanks Sergio Rubio*
*   added get_server_details mock code. *thanks Sergio Rubio*
*   list_servers uses mock data. *thanks Sergio Rubio*
*   added list_ssh_keys mock code. *thanks Sergio Rubio*
*   added power_cycle_server mock code. *thanks Sergio Rubio*
*   added power_off_server mock code. *thanks Sergio Rubio*
*   added power_on_server mock code. *thanks Sergio Rubio*
*   added reboot_server mock code. *thanks Sergio Rubio*
*   added shutdown_server mock code. *thanks Sergio Rubio*
*   added list_ssh_keys request tests. *thanks Sergio Rubio*
*   mark Server.reboot test pending if mocking. *thanks Sergio Rubio*
*   do not run at_exit block when mocking. *thanks Sergio Rubio*
*   mark Server.power_cycle test as pending when mocking. *thanks Sergio Rubio*
*   power state tests fixes. *thanks Sergio Rubio*
*   improve power state tests reliability. *thanks Sergio Rubio*
*   fix create_ssh_key request path. *thanks Sergio Rubio*
*   added destroy_ssh_key request and tests. *thanks Sergio Rubio*
*   added get_ssh_key request and tests. *thanks Sergio Rubio*
*   added create_ssh_key request tests. *thanks Sergio Rubio*
*   added SshKey model, collection and related tests. *thanks Sergio Rubio*
*   added ssh related requests, model and collection. *thanks Sergio Rubio*
*   power_state_tests fixes. *thanks Sergio Rubio*
*   list_ssh_keys request mock fixes. *thanks Sergio Rubio*
*   include response body in exception when request fails. *thanks Sergio Rubio*
*   Improved tests reliability. *thanks Sergio Rubio*
*   Added changelog. *thanks Sergio Rubio*

#### [docs::aws::cloudformation]
*   reformatted in YARD format. no content changes, just format changes. *thanks Weston Platter*

#### [docs::was::cdn]
*   reformatted in YARD format. no content changes, just format changes. *thanks Weston Platter*

#### [dreamhost|dns]
*   added missing changelog. *thanks Sergio Rubio*

#### [hp]
*   Add Accept header with application/json for all HP requests. *thanks Rupak Ganguly*

#### [hp|compute]
*   Add user_data option to create server call. *thanks Rupak Ganguly*
*   Consolidate the simple mapped options parameters in the create server call. *thanks Rupak Ganguly*
*   Add the capability to pass in user_data in the server model. *thanks Rupak Ganguly*
*   Add user_data to the mock data structure. *thanks Rupak Ganguly*
*   Fix mock for create server. *thanks Rupak Ganguly*
*   Add user_data option to create server call. *thanks Rupak Ganguly*
*   Consolidate the simple mapped options parameters in the create server call. *thanks Rupak Ganguly*
*   Add user_data to the mock data structure. *thanks Rupak Ganguly*
*   Fix mock for create server. *thanks Rupak Ganguly*

#### [hp|storage]
*   marker option in each method needs to be a string. *thanks Andreas Gerauer*

#### [libvirt|compute]
*   handle missing <system> tag in libvirt node info. *thanks Dominic Cleal*

#### [misc]
*   ovirt quota support. *thanks Amos Benari*
*   Removed Zerigo::Models::DNS::Records#find method, moved functionality to all(options)     Removed Rackspace::Models::DNS::Zones#find, moved functionality to all(options). *thanks Andreas Gerauer*
*   fixed infinite loop in each method of AWS Distributions. *thanks Andreas Gerauer*
*   add a test to protect certain Enumerable methods in Fog::Collection subclasses. *thanks Andreas Gerauer*
*   get rid of bucket/directory delete - not allowed for IA. *thanks Andrew Kuklewicz*
*   add IA specific headers for file. *thanks Andrew Kuklewicz*
*   get rid of versions from IA. *thanks Andrew Kuklewicz*
*   missed one. *thanks Andrew Kuklewicz*
*   fix tests, found a few differences with S3. *thanks Andrew Kuklewicz*
*   fix 1.8.7 error, oops. *thanks Andrew Kuklewicz*
*   fix internet archive use of headers, remove acls. *thanks Andrew Kuklewicz*
*   sshable should take the same options as ssh. *thanks Anshul Khandelwal*
*   [aws][glesys] Pass credentials to sshable. *thanks Anshul Khandelwal*
*   Use strict base encoding otherwise breaks for very large org names. *thanks Chirag Jog*
*   revert typo. *thanks Chirag Jog*
*   Fix the base encoding issue with Ruby 1.8.7 Compliance. *thanks Chirag Jog*
*   Delete \r also. *thanks Chirag Jog*
*   Minor fix: Ensure to send a valid Content-Type. *thanks Chirag Jog*
*   Check if a template requires a password or not. *thanks Chirag Jog*
*   Remove unecessary print. *thanks Chirag Jog*
*   Support optional `snapshot_id` key when creating volumes. *thanks Chris Roberts*
*   added dummy filters parameter to servers.all for conformity. *thanks Christoph Witzany*
*   Add Riak CS provider in Fog. *thanks Christopher Meiklejohn*
*   Updated DescribeReservedInstancesOfferings to take in filters as request parameters. *thanks Curtis Stewart*
*   OpenStack: base64 encode personality in rebuild. *thanks Dan Prince*
*   Forcing good Excon version. *thanks Daniel Libanori*
*   Update file.rb. *thanks Dave Ungerer*
*   Stop hardcoding the server ssh port. *thanks David Calavera*
*   Use passed blocks to handle scp callbacks. *thanks David Calavera*
*   fix syntax, ruby 1.8.7. *thanks Dmitry Dedov*
*   changed status to state for conformity and fixed alias for flavor_id. *thanks DoubleMalt*
*   replaced dup/delete with reject. *thanks Eugene Howe*
*   fixed for 1.8. *thanks Eugene Howe*
*   add ovirt quota support. *thanks Jason Montleon*
*   1620: Try to add some guards around possible nil objects based on associations in VPCs. *thanks Jesse Davis*
*   1620: Try to add some guards around possible nil objects based on associations in VPCs. *thanks Jesse Davis*
*   fix tabs. *thanks Jesse Davis*
*   First attempt at an S3 path_style flag. *thanks Joachim Nolten*
*   rebasing with master. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   removing superfluous readme. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   updated endpoint handing. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   rebasing. *thanks Kyle Rames*
*   merging in latest master. *thanks Kyle Rames*
*   fixing merge issues. *thanks Kyle Rames*
*   fixing merge issues. *thanks Kyle Rames*
*   merging in document changes. *thanks Kyle Rames*
*   rackspace|compute_v2] removing superfluous note from compute_v2 documentation. *thanks Kyle Rames*
*   merging in latest master. *thanks Kyle Rames*
*   mend. *thanks Kyle Rames*
*   Revert "[rackspace] adding note about credentials in the getting started document". *thanks Kyle Rames*
*   convert lib/fog to simply include all providers. *thanks Lance Ivy*
*   benchmark for loading all of fog vs just aws. *thanks Lance Ivy*
*   fix joyent and xenserver so they can be required individually. *thanks Lance Ivy*
*   restore ability to load fog from source without bundler. *thanks Lance Ivy*
*   fix bug where servers.all was ignoring filters due to hash merging in the wrong direction. *thanks Mick Pollard*
*   Fix S3 directory location infinite loop. *thanks Nils Landt*
*   Update changelog and bump version. *thanks Rupak Ganguly*
*   Fix names of the container sync attributes. *thanks Rupak Ganguly*
*   Add Object Storage container sync feature. *thanks Rupak Ganguly*
*   Update changelog and bump version. *thanks Rupak Ganguly*
*   supported OpenStack Quantum Router Operation. not include mock code. *thanks Tomokazu Hirai*
*   added mock code for router operation. *thanks Tomokazu Hirai*
*   fixed responce data from mock and removed vanilla options reject code. *thanks Tomokazu Hirai*
*   `@rubiojr` wrote mock code for openstack routers. *thanks Tomokazu Hirai*
*   `@rubiojr` fixed mock test failure. *thanks Tomokazu Hirai*
*   `@rubiojr` fixed mock faulure for router(s)_tests.rb. *thanks Tomokazu Hirai*
*   fix for AWS error message parsing. *thanks VirtualStaticVoid*
*   Added Content-Disposition attribute for Rackspace file. *thanks Yauheni Kryudziuk*
*   Changed GoogleAccessKeyId to GoogleAccessId. *thanks althras*
*   Add Vcloud support back to Fog::Compute. *thanks dJason*
*   add Rupak Ganguly to MVP exclusion list. *thanks geemus*
*   container sync attributes. *thanks howete*

#### [openstack]
*   added changelog. *thanks Sergio Rubio*

#### [openstack|compute]
*   Allow booting a VM with NICs (net_id, port_id, fixed_ip). *thanks Ferran Rodenas*
*   Use attribute accessor for nics. *thanks Ferran Rodenas*

#### [openstack|glance]
*   Added image service example. *thanks Sergio Rubio*

#### [openstack|identity]
*   moved identity example to the examples directory. *thanks Sergio Rubio*

#### [openstack|image]
*   Check for glance version (fog only supports v1). *thanks Ferran Rodenas*

#### [openstack|network]
*   Add endpoint_type option. *thanks Ferran Rodenas*
*   create_network provider extensions. *thanks Sergio Rubio*
*   Added missing router model/collection. *thanks Sergio Rubio*
*   update_router request updates. *thanks Sergio Rubio*
*   router model updates. *thanks Sergio Rubio*
*   create_router request updates. *thanks Sergio Rubio*
*   Added missing router related tests. *thanks Sergio Rubio*
*   create_network provider extensions reworked. *thanks Sergio Rubio*
*   remove extra trailing comma. *thanks Sergio Rubio*
*   remove superfluous Router model attributes. *thanks Sergio Rubio*
*   Fix #connection deprecation replacing it with #service. *thanks Sergio Rubio*
*   mock fixes in some OpenStack Network requests. *thanks Sergio Rubio*
*   added network/subnet/router related example. *thanks Sergio Rubio*

#### [openstack|storage]
*   Added support to impersonate other accounts. *thanks Sergio Rubio*
*   added missing mocks. *thanks Sergio Rubio*
*   Added storage example to set the account quota. *thanks Sergio Rubio*

#### [rackspace]
*   updated storage to support custom endpoints when using auth 2.0. *thanks Kyle Rames*
*   extracted auth 2.0 into module; updated cdn to support an external endpoint. *thanks Kyle Rames*
*   updated service_catalog.reload; added rackspace_cdn_url as an option to storage service; tweaked compute_v2 auth. *thanks Kyle Rames*
*   renaming variables in the interest of clarification. *thanks Kyle Rames*
*   updated to use v1 authentication if rackspace_auth_url endpoint is specified without version as with the current implementation of knife-rackspace. *thanks Kyle Rames*
*   initial checkin for the Getting started with Cloud Files document. *thanks Kyle Rames*
*   SPIKE: converting authentication module to super class. *thanks Kyle Rames*
*   updated to pass string rather and a uri to Fog::Connection. *thanks Kyle Rames*
*   created auth_token method in service that will return a token defined in the `@auth_token` variable to the identity service to reduce the chance that token might not be set; improved token tests. *thanks Kyle Rames*
*   made some methods private per `@brianhartsock.` *thanks Kyle Rames*
*   adding deprecation warning for auth v1.0/v1.1 authentication endpoints. *thanks Kyle Rames*
*   fixing yard warnings. *thanks Kyle Rames*
*   adding auth endpoint constants in Fog::Rackspace. *thanks Kyle Rames*
*   additional getting started document edits. *thanks Kyle Rames*
*   minor document update. *thanks Kyle Rames*
*   fixing constant already defined error for Fog::Rackspace::UK_AUTH_ENDPOINT and Fog::Rackspace::US_AUTH_ENDPOINT. *thanks Kyle Rames*
*   adding auth 2.0 to compute, databases, dns, load balancers, cloud block storage. *thanks Kyle Rames*
*   updated service endpoint handling; improved service endpoint tests. *thanks Kyle Rames*
*   moving require 'fog/rackspace/service' to fog/rackspace. *thanks Kyle Rames*
*   fixing auth 20 issue where tenant id is not being appended to the service url. *thanks Kyle Rames*
*   adjusting white space on documents. Added examples, additional resources, and support section to cloud files doc. *thanks Kyle Rames*
*   updated to normalize endpoints before detecting a standard endpoint. *thanks Kyle Rames*
*   making document edits. *thanks Kyle Rames*
*   fixing code error in documentation. *thanks Kyle Rames*
*   miscellaneous document tweaks. *thanks Kyle Rames*
*   added exception info to rackspace api documentation. *thanks Kyle Rames*
*   adding stragler. *thanks Kyle Rames*
*   fixing typo in api docs. *thanks Kyle Rames*
*   updated getting_started.md to use source 'https://rubygems.org' rather than :rubygems. *thanks Kyle Rames*
*   tweaking getting started page. *thanks Kyle Rames*
*   adding note about credentials in the getting started document. *thanks Kyle Rames*
*   adding note about credentials in the getting started document. *thanks Kyle Rames*
*   updated examples to use Chicago data center; updated error message to indicate we were using the Chicago data center. *thanks Kyle Rames*
*   revising getting started page. *thanks Kyle Rames*

#### [rackspace|block_storage]
*   initial document checkin. *thanks Kyle Rames*
*   edits to cloud block storage documentation. *thanks Kyle Rames*
*   adding link on getting_started.md to cloud block storage doc. *thanks Kyle Rames*
*   additional edits to the cloud block storage documentation. *thanks Kyle Rames*
*   initial checkin of block storage api documentation. *thanks Kyle Rames*
*   adding response documentaion. *thanks Kyle Rames*
*   updated yard docs for requests. *thanks Kyle Rames*

#### [rackspace|blockstorage]
*   adding Cloud Block Storage Examples. *thanks Kyle Rames*

#### [rackspace|cdn]
*   updated cdn to use auth 2.0. *thanks Kyle Rames*

#### [rackspace|compute_v2]
*   updated compute_v2 to use auth 2.0 endpoints. *thanks Kyle Rames*
*   updated to support auth 2.0. *thanks Kyle Rames*
*   fixing broken test. *thanks Kyle Rames*
*   added authentication_method test specifically for chef's default. *thanks Kyle Rames*
*   fixing yard doc. *thanks Kyle Rames*
*   updated compute_v2 to get the appropriate endpoint from the service catalog when an endpoint is specified via :rackspace_endpoint with one of the known constants (DFW_ENDPOINT, ORD_ENDPOINT, LON_ENDPOINT); updated compute examples to use rackspace region. *thanks Kyle Rames*
*   fixed chef issue. *thanks Kyle Rames*
*   updated detach volume to use :rackspace_region to specify region. *thanks Kyle Rames*
*   added specific exception for invalid states in order to make it easier to rescue. *thanks Kyle Rames*
*   added bootstrap and ssh section to compute documentation. *thanks Kyle Rames*
*   updated the bootstrap section of the compute_v2 documentation. *thanks Kyle Rames*

#### [rackspace|identity]
*   updated test to support ruby 1.8.7. *thanks Kyle Rames*

#### [rackspace|storage]
*   initial cloud file examples checkin. *thanks Kyle Rames*
*   fixing typos. *thanks Kyle Rames*
*   renaming examples. *thanks Kyle Rames*
*   updating to use 2.0 authentication endpoints. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   fixing example spacing. *thanks Kyle Rames*
*   adding rackspace storage docs; general edits on other rackspace documents. *thanks Kyle Rames*
*   adding Storage yard docs. *thanks Kyle Rames*
*   updating the download file section. *thanks Kyle Rames*
*   updating download example to use a block. *thanks Kyle Rames*
*   updating auth endpoints in documentation. *thanks Kyle Rames*
*   fixing typos. *thanks Kyle Rames*

#### [xenserver|compute]
*   added create_vlan request. *thanks Sergio Rubio*
*   added destroy_vlan request. *thanks Sergio Rubio*
*   added create_vlan request tests. *thanks Sergio Rubio*
*   added destroy_vlan request tests. *thanks Sergio Rubio*
*   added create_network request. *thanks Sergio Rubio*
*   added create_network tests. *thanks Sergio Rubio*
*   added destroy_network request. *thanks Sergio Rubio*
*   added destroy_network request tests. *thanks Sergio Rubio*
*   added VLAN model and tests. *thanks Sergio Rubio*
*   Added Vlans collection and tests. *thanks Sergio Rubio*
*   added save and destroy operations to Network. *thanks Sergio Rubio*
*   updated compute service to add new model, requests. *thanks Sergio Rubio*
*   Added Network/VLANs creation example. *thanks Sergio Rubio*
*   update changelog. *thanks Sergio Rubio*


## 1.10.0 03/05/2013
*Hash* 2f30de2ab357a5bbdb505b94ada8aa637ba936f5

Statistic     | Value
------------- | --------:
Collaborators | 45
Downloads     | 1813647
Forks         | 720
Open Issues   | 117
Watchers      | 2386

**MVP!** Rupak Ganguly

#### [Brightbox]
*   Adds update firewall request. *thanks Paul Thornthwaite*
*   Adds compatibility mode to template. *thanks Paul Thornthwaite*
*   Updates to requests. *thanks Paul Thornthwaite*

#### [Glesys]
*   Template list request does not take options. *thanks Simon Gate*
*   Only make one request when fetching templates. *thanks Simon Gate*
*   Fix template attributes, now they work. *thanks Simon Gate*
*   Attribute :keepip removed from server model. *thanks Simon Gate*
*   Clean up attributes on server model. *thanks Simon Gate*
*   Add public_ip_method to server model. *thanks Simon Gate*
*   Add setup method to copy fog ssh keys to server. *thanks Simon Gate*
*   Wrap ssh method to use rootpassword if present. *thanks Simon Gate*

#### [HP]
*   Add BlockStorage provider and add volumes and snapshots support. Add support for bootable volumes, persistent server, cross-tenant acls and temp urls. Add support for Windows instances. Merge the latest code from fog 1.9.0 release. *thanks Rupak Ganguly*

#### [HP|storage]
*   Fix generate_object_temp_url to use signer that is backward compatible to 1.8.7. *thanks Rupak Ganguly*

#### [Rackspace|Compute]
*   fixed issue with bootstrap method where server was ready, but it had not received an ipv4 address yet. Added check for ip address in server ready block as well as a timeout parameter. *thanks Kyle Rames*

#### [Rackspace|Storage]
*   This tests consistently fails on either ruby 1.8.7 or ruby 1.9.3 because hash order is indeterminate. I believe the spirt of this test is to ensure that only one header value is generated and thus I have updated the test to reflect that. *thanks Kyle Rames*

#### [aws]
*   Fixes typo in fetching credentials error. *thanks Paul Thornthwaite*
*   Fixes security group template. *thanks Paul Thornthwaite*

#### [aws|compute]
*   Fixes schema in image tests. *thanks Paul Thornthwaite*

#### [aws|dynamodb]
*   fix port to match https default     closes #1531. *thanks geemus*

#### [aws|rds]
*   remove some superfluous reloads, hopefully help with travis test timing issues. *thanks geemus*

#### [aws|storage]
*   Fixes Yard tags. *thanks Paul Thornthwaite*

#### [bluebox|blb]
*   clean up, define types returned. *thanks Josh Yotty*
*   some cleanup of model stubs. *thanks Josh Yotty*
*   add model to application and server collections. *thanks Josh Yotty*
*   require model. *thanks Josh Yotty*
*   require model. *thanks Josh Yotty*
*   fix more stub/copypaste inanity. *thanks Josh Yotty*
*   lb_service collection implementation. *thanks Josh Yotty*
*   service must be passed from caller. *thanks Josh Yotty*
*   atone for additional sins in the lb service and backend models. *thanks Josh Yotty*
*   add last set of index requests for lb_machines. *thanks Josh Yotty*
*   add_machine. *thanks Josh Yotty*
*   rename for consistency. *thanks Josh Yotty*
*   typo, whitespace. *thanks Josh Yotty*
*   lb_machine API coverage. *thanks Josh Yotty*
*   missing end. *thanks Josh Yotty*
*   testing stubs. *thanks Josh Yotty*
*   rename to tests, plural. *thanks Josh Yotty*
*   more request tests, missing comma. *thanks Josh Yotty*
*   parsing is hard, let's go shopping. *thanks Josh Yotty*
*   account for text/plain endpoint. *thanks Josh Yotty*
*   update tests. *thanks Josh Yotty*

#### [core]
*   Uses Logger deprecation for Compute.new. *thanks Paul Thornthwaite*
*   Fix display_stdout to process multiple lines output. *thanks Rupak Ganguly*

#### [dreamhost|dns]
*   remove connection deprecation notices. *thanks Sergio Rubio*
*   Use the new fog-dream.com domain for testing. *thanks Sergio Rubio*
*   remove silly debugging code. *thanks Sergio Rubio*
*   do not delete the do-not-delete record when testing. *thanks Sergio Rubio*
*   added test helpers. *thanks Sergio Rubio*
*   Added README.md file documenting testing procedure. *thanks Sergio Rubio*
*   Removed get_record request. *thanks Sergio Rubio*
*   refactor dns requests tests. *thanks Sergio Rubio*
*   added Record model tests, fix Record.save. *thanks Sergio Rubio*
*   record tests fixes. *thanks Sergio Rubio*
*   Emulate zone model and collection, added tests. *thanks Sergio Rubio*
*   Do not add duplicated zones to the Zones collection. *thanks Sergio Rubio*
*   Moved getting started guide to examples/dns. *thanks Sergio Rubio*
*   Zone.records: list only records matching the current zone. *thanks Sergio Rubio*
*   Updated testing documentation. *thanks Sergio Rubio*
*   Updated Dreamhost/DNS getting started guide. *thanks Sergio Rubio*
*   drop uuid gem requirements, not needed. *thanks Sergio Rubio*
*   drop uuid gem dep from fog.gemspec. *thanks Sergio Rubio*
*   Add dreamhost to the list of providers. *thanks Sergio Rubio*

#### [dreamhost|docs]
*   Added getting started guide, initial release. *thanks Sergio Rubio*

#### [dremhost|dns]
*   added DNS service tests. *thanks Sergio Rubio*

#### [ecloud]
*   fixed object returns in mock. *thanks Eugene Howe*

#### [fog]
*   Typo fixed in identity. *thanks Anshul Khandelwal*
*   Cleanup:  Use the service registry for requiring libs where possible. *thanks Anshul Khandelwal*

#### [glesys]
*   Add description to server model. *thanks Simon Gate*
*   Ability to pass in options to server details. *thanks Simon Gate*
*   Consistent naming of attributes. *thanks Simon Gate*
*   ip details should be ip details, not listfree. *thanks Simon Gate*
*   Fix ip model name to match nameing convention. *thanks Simon Gate*
*   Fix ip attributes, they didn't work. *thanks Simon Gate*
*   Return nil if there isn't any public ip address. *thanks Simon Gate*
*   Refactor the ip interface, did not work earlier. *thanks Simon Gate*
*   add take method to ip model. *thanks Simon Gate*
*   Fix error in ip tests. *thanks Simon Gate*
*   Make compute test pass. *thanks Simon Gate*
*   Attributes were overwritten when getting server details. *thanks Simon Gate*
*   Fix bug when trying to attach a ip to a server. *thanks Simon Gate*
*   Platform methods to templates. *thanks Simon Gate*
*   Rename template model to match Fog convention. *thanks Simon Gate*
*   Remove unused features from template model. *thanks Simon Gate*

#### [hp/openstack|compute]
*   remove erroneous block argument to get_object; fixes issue #1588 for OpenStack and HP. *thanks Kyle Rames*

#### [libvirt|volume]
*   Fix typo in image_suffix. *thanks David Wittman*

#### [misc]
*   Enable ebs-optimized spot instance requests. *thanks Adam Bozanich*
*   test spot instance request parser. *thanks Adam Bozanich*
*   add internet_archive to fog providers, bin, storage. *thanks Andrew Kuklewicz*
*   and internet_archive code, tests. *thanks Andrew Kuklewicz*
*   fix testing mock. *thanks Andrew Kuklewicz*
*   set defaults to be scheme http, port 80, as that is what internet_archive supports. *thanks Andrew Kuklewicz*
*   Pass the management URI if no public endpoint. *thanks BK Box*
*   Need to check for management variable as well. *thanks BK Box*
*   Add support for pulling out virtualization type when parsing AWS     Describe Instances results. *thanks Brad Heller*
*   Ignore tags. *thanks Brad Heller*
*   NextMarker => NextToken. Maybe that's what it used to be...?. *thanks Brad Heller*
*   Fix Params related to network configuration. *thanks Chirag Jog*
*   Support to Configure the VM network. *thanks Chirag Jog*
*   Ability to track vApp level status of readiness. *thanks Chirag Jog*
*   Fix Params related to network configuration. *thanks Chirag Jog*
*   Support to Configure the VM network. *thanks Chirag Jog*
*   Ability to track vApp level status of readiness. *thanks Chirag Jog*
*   Remove extraneous print. *thanks Chirag Jog*
*   Remove existing (unused) parser module and introduce a     TerremarkParser - which extends the base parser with the ability to     extract relevant attributes. *thanks Chirag Jog*
*   Use the TerremarkParser to extract relevant attributes. *thanks Chirag Jog*
*   Minor Fix to delete the internet service. *thanks Chirag Jog*
*   OpenStack: update used limits tests. *thanks Dan Prince*
*   OpenStack: update tenant_list tests. *thanks Dan Prince*
*   OpenStack: get identity tests passing in real mode. *thanks Dan Prince*
*   Drop 'extras' from tenant test validations. *thanks Dan Prince*
*   Openstack: fix bin/openstack.rb errors. *thanks Dan Prince*
*   OpenStack Compute: Fix server model metadata. *thanks Dan Prince*
*   OpenStack: Add missing metadatum requests. *thanks Dan Prince*
*   vsphere: Support multiple NIC backings. *thanks Ewoud Kohl van Wijngaarden*
*   vsphere: Allow listing virtual port groups. *thanks Ewoud Kohl van Wijngaarden*
*   Add a zones.find(substring) method to return only zones whose     name matches that substring. *thanks H. Wade Minter*
*   Add initial support for pulling in >100 zones via Zones.each. *thanks H. Wade Minter*
*   Get rid of the extra load() calls. *thanks H. Wade Minter*
*   copy & paste to get Blocks LB API working. *thanks Josh Yotty*
*   register blb feature. *thanks Josh Yotty*
*   Rudimentary CRUD for AWS Data Pipeline. *thanks Keith Barrette*
*   Simple model tests. *thanks Keith Barrette*
*   Simple request tests. *thanks Keith Barrette*
*   Fix failing model tests. *thanks Keith Barrette*
*   Mark data pipeline tests pending if mocked. *thanks Keith Barrette*
*   Make compatible with Ruby 1.8.7. *thanks Keith Barrette*
*   Finished initial draft of Cloud Server docs. *thanks Kyle Rames*
*   updating Rackspace Cloud Server Documentation. *thanks Kyle Rames*
*   moving documents to another branch. *thanks Kyle Rames*
*   adding white space to force travis build. *thanks Kyle Rames*
*   refined examples; moved samples into cloud_servers sub directory. *thanks Kyle Rames*
*   moving examples; added readme. *thanks Kyle Rames*
*   tweaking example readme file. *thanks Kyle Rames*
*   tweaking examples document. *thanks Kyle Rames*
*   merging with latest master. *thanks Kyle Rames*
*   Adding Rackspace getting started and compute documents back in. *thanks Kyle Rames*
*   apply edits to Rackspace compute documents. *thanks Kyle Rames*
*   fixing links to anchors in Rackspace Compute doc. *thanks Kyle Rames*
*   fixing links to anchors in Rackspace Compute doc one more time. *thanks Kyle Rames*
*   fixing links to anchors in Rackspace Compute doc AGAIN. *thanks Kyle Rames*
*   fixing merge conflicts. *thanks Kyle Rames*
*   added 30 second timeout for SSH and SCP connect. *thanks Kyle Rames*
*   moved cloud servers examples to lib/fog/rackspace/examples/compute_v2; renamed cloud_servers.md to compute_v2.md. *thanks Kyle Rames*
*   rebased with master. *thanks Kyle Rames*
*   merging with the latest file_metadata. *thanks Kyle Rames*
*   rebasing cdn branch with latest master. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   rebasing with master. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   Revert "[rackspace] adding accept headers to block_storage, cdn, compute_v2, databases, identity, load_balancers, storage". *thanks Kyle Rames*
*   Revert "Revert "[rackspace] adding accept headers to block_storage, cdn, compute_v2, databases, identity, load_balancers, storage"". *thanks Kyle Rames*
*   Follow redirection from response even if response is a Hash. *thanks Marc G Gauthier*
*   Set the User-Agent as Fog, to help differentiate from HP's CLI tools that have a vendored 'hpfog'. *thanks Matt Ray*
*   Make sure no requests are ever sent to the wrong endpoint by default. *thanks Matt Sanders*
*   Bump release to 0.0.7. *thanks Matt Sanders*
*   Remove matt as contact. *thanks Matt Sanders*
*   Bumped net-scp dependency to ~>1.1. *thanks Michael D. Hall*
*   remove unneeded url param. *thanks Michał Krzyżanowski*
*   Fix Mock#allocate_address method arity. *thanks Mike Moore*
*   Fix Mock#get_snapshot_details argument. *thanks Mike Moore*
*   Fix Mock#get_volume_details argument. *thanks Mike Moore*
*   Fix Mock#list_servers method arity. *thanks Mike Moore*
*   Fix Mock#remove_fixed_ip arguments. *thanks Mike Moore*
*   Fix Mock#update_server arguments. *thanks Mike Moore*
*   Removes docs since they are in wrong repo. *thanks Paul Thornthwaite*
*   Adds new Code Climate badge to README. *thanks Paul Thornthwaite*
*   Disables tests with race conditions affecting CI. *thanks Paul Thornthwaite*
*   Update gitignore and add a rvmrc file. *thanks Rupak Ganguly*
*   Add a new HP provider. *thanks Rupak Ganguly*
*   Add a case for the new HP provider. *thanks Rupak Ganguly*
*   Add a new HP provider. *thanks Rupak Ganguly*
*   Add a storage service implementation to the HP provider. *thanks Rupak Ganguly*
*   Add #get_containers, #get_container, #put_container and #delete_container methods to the storage service. *thanks Rupak Ganguly*
*   Add #head_containers and #head_container methods. *thanks Rupak Ganguly*
*   Enable #get, #put, #head and #delete object methods. *thanks Rupak Ganguly*
*   Add implementation for #get_object method. *thanks Rupak Ganguly*
*   Add implementation for #put_object method. *thanks Rupak Ganguly*
*   Add implementation for #head_object method. *thanks Rupak Ganguly*
*   Add implementation for #delete_object method. *thanks Rupak Ganguly*
*   Enable models layer methods and return nil from cdn call. *thanks Rupak Ganguly*
*   Add the directories model implementation. *thanks Rupak Ganguly*
*   Add the directory model implementation. *thanks Rupak Ganguly*
*   Add the files model implementation. *thanks Rupak Ganguly*
*   Add the file model implementation. *thanks Rupak Ganguly*
*   Add an implementation of copy method to copy files between containers. *thanks Rupak Ganguly*
*   Require HP provider for the fog binary. *thanks Rupak Ganguly*
*   Add a HP provider class for the fog binary. *thanks Rupak Ganguly*
*   Enable compute service with HP provider. Refactor hp_auth_url into hp_host, hp_port and hp_auth_path to enable flexibility in specifying the host, port and auth path separately. *thanks Rupak Ganguly*
*   Add the new hp_host, hp_port and hp_auth_path attributes and remove hp_auth_url. *thanks Rupak Ganguly*
*   Add a new HP provider for compute service. Note the new hp_host, hp_port and hp_auth_path attributes. *thanks Rupak Ganguly*
*   Add a case for the new HP provider for compute service. *thanks Rupak Ganguly*
*   Add the #list_servers method. *thanks Rupak Ganguly*
*   Enable #create_server, #list_servers and #list_servers_detail services for Nova. *thanks Rupak Ganguly*
*   Add implementation for #list_servers_detail. *thanks Rupak Ganguly*
*   Enable #list_images and #list_images_detail services. *thanks Rupak Ganguly*
*   Add implementation for #list_images service. *thanks Rupak Ganguly*
*   Add implementation for #list_images_detail service. *thanks Rupak Ganguly*
*   Enable #list_flavors and #list_flavors_detail services for Nova. *thanks Rupak Ganguly*
*   Add implementation for #list_flavors service. *thanks Rupak Ganguly*
*   Add implementation for #list_flavors_detail service. *thanks Rupak Ganguly*
*   Add implementation for #get_server_details service. *thanks Rupak Ganguly*
*   Add implementation for #get_image_details service. *thanks Rupak Ganguly*
*   Add implementation for #get_flavor_details service. *thanks Rupak Ganguly*
*   Enable #get_server_details, #get_image_details and #get_flavor_details services for Nova. *thanks Rupak Ganguly*
*   Add implementation for #create_server service. *thanks Rupak Ganguly*
*   Enable #create_image and #delete_image services. *thanks Rupak Ganguly*
*   Add implementation for #create_image service. *thanks Rupak Ganguly*
*   Add implementation for #delete_image service. *thanks Rupak Ganguly*
*   Enable the #create_server, #update_server and #delete_server services for Nova. *thanks Rupak Ganguly*
*   Update code with differences from Rackspace API and OS, to make it work with the Nova instance. *thanks Rupak Ganguly*
*   Add the implementation for #update_server services. *thanks Rupak Ganguly*
*   Add the implementation for #delete_server services. *thanks Rupak Ganguly*
*   Enable #list_addresses, #list_public_addresses and #list_private_addresses services for Nova. *thanks Rupak Ganguly*
*   Add implementation for #list_addresses service. *thanks Rupak Ganguly*
*   Add implementation for #list_public_addresses service. *thanks Rupak Ganguly*
*   Add implementation for #list_private_addresses service. *thanks Rupak Ganguly*
*   Enable  #server_action, #reboot_server, #resize_server, #confirm_resized_server and #revert_resized services for Nova. *thanks Rupak Ganguly*
*   Add implementation for #server_action, #reboot_server, #resize_server, #confirm_resized_server and #revert_resized services. *thanks Rupak Ganguly*
*   Enable flavors and flavor models. *thanks Rupak Ganguly*
*   Add implementation for flavors and flavor model layer. *thanks Rupak Ganguly*
*   Enable images and image models. *thanks Rupak Ganguly*
*   Add implementation for images and image model layers. *thanks Rupak Ganguly*
*   Enable models for servers and server for Nova services. *thanks Rupak Ganguly*
*   Add implementaion for servers model. *thanks Rupak Ganguly*
*   Add implementaion for server model. *thanks Rupak Ganguly*
*   Refactor connection parameters to accept a single endpoint and credentials. *thanks Rupak Ganguly*
*   Refactor Nova connection parameters to accept a single endpoint and credentials. *thanks Rupak Ganguly*
*   Add a options hash so that headers can be passed in to set acls. *thanks Rupak Ganguly*
*   Fix public_url property to generate a url when cdn is not enabled. Also, create a new url method that returns the full url. *thanks Rupak Ganguly*
*   Add a helper method to convert a acl string to a header name/value pair that Swift understands. *thanks Rupak Ganguly*
*   Add an acl property that will allow setting of acls strings. Also, add fix the public property to now toggle the appropriate acl string. *thanks Rupak Ganguly*
*   Remove Content-Length header incase Transfer-Encoding header is present. This was done to get the streaming for PUT working. *thanks Rupak Ganguly*
*   Fix a JSON parse error for Nova service methods like reboot. The server returns plain text instead of JSON text and hence JSON.parse barfs. *thanks Rupak Ganguly*
*   Revise fog gemspec to reflect hpfog name and tag it with v0.0.6. *thanks Rupak Ganguly*
*   Add mocking support to Swift HP provider calls. *thanks Rupak Ganguly*
*   Add a public? method to query a directory's state. *thanks Rupak Ganguly*
*   Add header_to_acl helper method to convert an acl header into corresponding acl strings. *thanks Rupak Ganguly*
*   Retrieve acl headers if present and set the acl string on a directory. *thanks Rupak Ganguly*
*   Add a check to see if acl string is nil and if so set it to 'private'. *thanks Rupak Ganguly*
*   Change serverRef to serverId. This was a change from Rackspace API but has been sync'd upon now. *thanks Rupak Ganguly*
*   Change flavorRef to flavorId and imageRef to imageId. This was a change from Rackspace API but has been sync'd upon now. *thanks Rupak Ganguly*
*   Fix DEVEX-634: Remove services that our out of scope. *thanks Rupak Ganguly*
*   Add CHANGELOG for HP specific fog extensions. *thanks Rupak Ganguly*
*   Add README with documentation for HP specific fog extensions. *thanks Rupak Ganguly*
*   Bump version. *thanks Rupak Ganguly*
*   Fix differences that were there in OS API. *thanks Rupak Ganguly*
*   Add special char. support including '?' in container and object names. *thanks Rupak Ganguly*
*   Add a helper method to expose some base info. for clients. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Fix bug DEVEX-1296. Encode container and object names for public_url. *thanks Rupak Ganguly*
*   Update changelog. *thanks Rupak Ganguly*
*   Update date for release. *thanks Rupak Ganguly*
*   Change flavorId to flavorRef and imageId to imageRef as the specs changed. Also, change expected status to be 202 instead of 200. *thanks Rupak Ganguly*
*   Change expected status to be 204 instead of 202. *thanks Rupak Ganguly*
*   Change expected status to be 204 instead of 200. *thanks Rupak Ganguly*
*   Update date for fog merge with upstream milestone. *thanks Rupak Ganguly*
*   Add connection options param to the HP provider for Storage and Compute services that can be used to customize various connection related timeouts and other options. *thanks Rupak Ganguly*
*   Remove deprecated provider recognize clause. *thanks Rupak Ganguly*
*   Enable HP CDN provider. *thanks Rupak Ganguly*
*   Integrate HP CDN service with storage service. *thanks Rupak Ganguly*
*   Fix small bug with returning public url in the case when cdn is used. *thanks Rupak Ganguly*
*   Add initial implementation for cdn services i.e. GET, PUT, POST, HEAD and DELETE. *thanks Rupak Ganguly*
*   Hardcode X-Storage-Url as service is returning wrong url. *thanks Rupak Ganguly*
*   Assign hp_auth_uri to an instance var. so that CDN can use it. *thanks Rupak Ganguly*
*   Enable delete_container on the CDN service. *thanks Rupak Ganguly*
*   Add fix for special chars. in CDN-enabled container names. *thanks Rupak Ganguly*
*   Catch new exception that is being thrown. *thanks Rupak Ganguly*
*   Update code to call delete_container if CDN is enabled. *thanks Rupak Ganguly*
*   Make headers camel cased in public_url and remove manipulation of public_url in save method. Use delete_container in CDN context instead of out_container. *thanks Rupak Ganguly*
*   Remove CDN integration from within Storage service, till CDN service is more mature. *thanks Rupak Ganguly*
*   Update image and images model, and create_image call now uses server_action. Behavior change in Diablo 4. *thanks Rupak Ganguly*
*   Add new request layer method for rebuild_server and enable it for compute services. Behavior added in Diablo 4. *thanks Rupak Ganguly*
*   Enable new compute services. *thanks Rupak Ganguly*
*   Add name, accessIPv4 and accessIPv6 as properties. Change create_server signature to include the now required name param. Breaking change due to OS API. *thanks Rupak Ganguly*
*   Add new attributes, update flavor and image attributes and add corresponding accessors for them. Add new methods for rebuild, resize, revert_resize, confirm_resize, and create_image. Update save method to use new attributes. Update create_server call to pass in name param. *thanks Rupak Ganguly*
*   Remove resize related calls as they are not fully functional yet. *thanks Rupak Ganguly*
*   Update changelog for 0.0.10 tagged version. *thanks Rupak Ganguly*
*   Add a new option for CDN endpoint url and build the CDN mgmt url. *thanks Rupak Ganguly*
*   Add a new cdn uri to the Storage service to enable a CDN service from within the Storage service. *thanks Rupak Ganguly*
*   Update destroy and save methods to call appropriate CDN counterparts when CDN service is available and enabled. *thanks Rupak Ganguly*
*   Add some new attributes. Fix image_id and flavor_id getters. *thanks Rupak Ganguly*
*   Add request and model methods for change_password_server, and enable it for compute. *thanks Rupak Ganguly*
*   Add list_key_pairs compute request layer method, and mocks for it as well. *thanks Rupak Ganguly*
*   Add some mocking helper methods. *thanks Rupak Ganguly*
*   Fix issue with list in mock mode. *thanks Rupak Ganguly*
*   Enable create_key_pair service for compute. Add key_pairs array for mocking support. *thanks Rupak Ganguly*
*   Add implementation for creating keypair and also provide mocking support. *thanks Rupak Ganguly*
*   Remove a debug message. *thanks Rupak Ganguly*
*   Fix param name. *thanks Rupak Ganguly*
*   Enable delete_key_pair request method and implement it, along with mocking support. *thanks Rupak Ganguly*
*   Enable and implement key pairs model layer for compute service. *thanks Rupak Ganguly*
*   Add implementation for list_security_groups request layer method and enable it for compute services. Add mocking support as well. *thanks Rupak Ganguly*
*   Fix a small typo in mocks. *thanks Rupak Ganguly*
*   Enable and implemented create_security_groups method for request layer for compute services. *thanks Rupak Ganguly*
*   Fix code to remove from last modified hash afetr delete in mock code. *thanks Rupak Ganguly*
*   Use id instead of name to index the security groups hash in mock data structure. *thanks Rupak Ganguly*
*   Enable and implemented delete_security_groups method in requets layer for compute services. *thanks Rupak Ganguly*
*   Enable and implement create, get and delete security group methods for compute service. *thanks Rupak Ganguly*
*   Enable and add the security groups model layer implementation for the compute services. *thanks Rupak Ganguly*
*   Enable and add implementation for create security group rules for compute service. *thanks Rupak Ganguly*
*   Fix bugs in mocking support. *thanks Rupak Ganguly*
*   Small fix in mocks. *thanks Rupak Ganguly*
*   Enable and implement delete security group rules for compute service. *thanks Rupak Ganguly*
*   Add security group rule methods to security group model. *thanks Rupak Ganguly*
*   Fix create_rule to return response instead of boolean. *thanks Rupak Ganguly*
*   Add helper methods for mocking. *thanks Rupak Ganguly*
*   Enable and implement allocate address with mocking support for compute services. *thanks Rupak Ganguly*
*   Add options for keyname, security group and availability zone. *thanks Rupak Ganguly*
*   Enable and add implementation for release address for request layer for the compute service. *thanks Rupak Ganguly*
*   Fix documentation. *thanks Rupak Ganguly*
*   Enable and implement get address for request layer along with mocking support for the compute service. *thanks Rupak Ganguly*
*   Rename these to add a server prefix as they pertain to server addresses. *thanks Rupak Ganguly*
*   Enable and implement list addresses for request layer for the compute service. *thanks Rupak Ganguly*
*   Enable and implement the address model layer for the compute service. *thanks Rupak Ganguly*
*   Fix the documentation. *thanks Rupak Ganguly*
*   Enable and add associating and disassociating addresses to a server instance in the request layer for the compute service. *thanks Rupak Ganguly*
*   Add new attributes and revise addresses hash structure for the mock. *thanks Rupak Ganguly*
*   Fix doc, and status. *thanks Rupak Ganguly*
*   Revise implementation for returning private and public ip addresses for a given server, along with mocking support. *thanks Rupak Ganguly*
*   Revise mocking support to manage ip address collection in servers. *thanks Rupak Ganguly*
*   Add server attribute to associate and disassociate a server to an address. *thanks Rupak Ganguly*
*   Remove some attributes from object. *thanks Rupak Ganguly*
*   Add support for passing in key pairs, security groups, availability zone and min/max count to the create server request layer method. *thanks Rupak Ganguly*
*   Update the server model to support passing in keypairs and security groups. *thanks Rupak Ganguly*
*   Fix some verbiage and update some links. *thanks Rupak Ganguly*
*   Remove instance_id as an accessor. *thanks Rupak Ganguly*
*   Add vcpus as an attribute. *thanks Rupak Ganguly*
*   Add back some attributes. *thanks Rupak Ganguly*
*   Update inline docs to add some params. *thanks Rupak Ganguly*
*   Update changelog with changes for this version release. *thanks Rupak Ganguly*
*   Bump version to 0.0.11. *thanks Rupak Ganguly*
*   Update HP provider with the new CS authentication method and also refactor the legacy authentication method. Also, update HP Storage provider to use the CS authentication scheme. *thanks Rupak Ganguly*
*   Retrofit HP Storage provider to work with both legacy and CS authentication schemes. *thanks Rupak Ganguly*
*   Refactor code to get endpoints from service catalog for v1 and v2 auths. *thanks Rupak Ganguly*
*   Update Storage provider to work with v1 and v2 auths. *thanks Rupak Ganguly*
*   Update CDN provider to work with v1 and v2 auths. Also, patch code for incorrect endpoint via CS catalog. *thanks Rupak Ganguly*
*   Update for cdn endpoint fix in place. *thanks Rupak Ganguly*
*   Update inline docs as per real responses. *thanks Rupak Ganguly*
*   Update CDN integration with Storage with respect to CS authentication. *thanks Rupak Ganguly*
*   Update HP Compute provider to use CS authentication and retrofit code to use v1 auth as well. *thanks Rupak Ganguly*
*   Add cdn_enabled?, cdn_enable= and cdn_public_url for directory model. Also, add cdn_public_url for file model. *thanks Rupak Ganguly*
*   Add connection_options for AWS Compute provider. *thanks Rupak Ganguly*
*   Refactor to remove service_type param from provider call. *thanks Rupak Ganguly*
*   Update inline documentation. *thanks Rupak Ganguly*
*   Escape the key in the call. *thanks Rupak Ganguly*
*   Remove bits and cores from flavor. *thanks Rupak Ganguly*
*   Add cores as an attribute to alias vcpus. *thanks Rupak Ganguly*
*   Add some attributes that are implemented as methods. *thanks Rupak Ganguly*
*   Add copyright message for HP extensions for fog. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Update copyright notice. *thanks Rupak Ganguly*
*   Update inline documentation. *thanks Rupak Ganguly*
*   Fix for auth uri using Identity service. *thanks Rupak Ganguly*
*   Add parameter :hp_avl_zone to access the az2 availability zone to the HP Compute provider. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Add key_pair get/set methods for server model. *thanks Rupak Ganguly*
*   Hack to fix  public_ip_address. *thanks Rupak Ganguly*
*   Fix for Fog::HP::CDN::NotFound exception. *thanks Rupak Ganguly*
*   Update public_ip_address method to return first public ip address. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Add an Errors module for handling HP provider specific exceptions. *thanks Rupak Ganguly*
*   Refactor escape method for container and object names and move it to the HP provider from individual namespaces. *thanks Rupak Ganguly*
*   Remove obsolete method. *thanks Rupak Ganguly*
*   Remove bad service. *thanks Rupak Ganguly*
*   Fix mock to return integer value for count. *thanks Rupak Ganguly*
*   Raise the correct exception in the mock. *thanks Rupak Ganguly*
*   Add HP provider and credentials to support testing with mocks. *thanks Rupak Ganguly*
*   Fix mocks to match real implementation. *thanks Rupak Ganguly*
*   Add object tests for storage. *thanks Rupak Ganguly*
*   Add mocking support for copy operation using puut object. *thanks Rupak Ganguly*
*   Add more tests for containers and objects. *thanks Rupak Ganguly*
*   Fix an issue in copy mocking portion. *thanks Rupak Ganguly*
*   Add test for copy objects. *thanks Rupak Ganguly*
*   Add test for copying from one container to another. *thanks Rupak Ganguly*
*   Fix format of flavors in mocks. *thanks Rupak Ganguly*
*   Add tests for flavor. *thanks Rupak Ganguly*
*   Add implementation for mocks. *thanks Rupak Ganguly*
*   Add mocking support. *thanks Rupak Ganguly*
*   Minor fix for mocks. *thanks Rupak Ganguly*
*   Add tests for images. *thanks Rupak Ganguly*
*   Update mocking support. *thanks Rupak Ganguly*
*   Add tests for server requests. *thanks Rupak Ganguly*
*   Update mocking support. *thanks Rupak Ganguly*
*   Add tests for addresses and floating ips. *thanks Rupak Ganguly*
*   Fix minor things in tests. *thanks Rupak Ganguly*
*   Update mocking support. *thanks Rupak Ganguly*
*   Add tests for keypairs. *thanks Rupak Ganguly*
*   Update mocking support for security groups. *thanks Rupak Ganguly*
*   Add tests for security groups. *thanks Rupak Ganguly*
*   Update mocking support for security groups and security group rules. *thanks Rupak Ganguly*
*   Add tests for security group rules. *thanks Rupak Ganguly*
*   Fix mocks for create_key_pair. *thanks Rupak Ganguly*
*   Fix mocks for list_key_pairs. *thanks Rupak Ganguly*
*   Fix format for list_key_pairs. *thanks Rupak Ganguly*
*   Add tests for address model and addresses collection. *thanks Rupak Ganguly*
*   Add HP provider in the helper. *thanks Rupak Ganguly*
*   Add tests for key_pair model and key_pairs collection. *thanks Rupak Ganguly*
*   Add tests for security group model and collection. *thanks Rupak Ganguly*
*   Add HP credential params. *thanks Rupak Ganguly*
*   Add HP credential params for mocking support. *thanks Rupak Ganguly*
*   Add mocking support for HP CDN provider. *thanks Rupak Ganguly*
*   Add tests for CDN containers. *thanks Rupak Ganguly*
*   Update mocks to simulate real results in containers. *thanks Rupak Ganguly*
*   Update tests and mocks based on real pro data. *thanks Rupak Ganguly*
*   Update tests and mock formats based on real pro data. *thanks Rupak Ganguly*
*   Update mocks to simulate real behavior. *thanks Rupak Ganguly*
*   Update key pair tests to work with real pro results. *thanks Rupak Ganguly*
*   Update mocks to simulate real results. *thanks Rupak Ganguly*
*   Update mocks and tests to simulate real results. *thanks Rupak Ganguly*
*   Update mocks and tests to simulate real results. *thanks Rupak Ganguly*
*   Update mocks and tests for flavor to simulate real results. *thanks Rupak Ganguly*
*   Update mocks and tests to simulate real calls in pro. *thanks Rupak Ganguly*
*   Update mocks for address in create_server and corresponding tests. *thanks Rupak Ganguly*
*   Add hp_tenant_id as a required param for connection to HP providers. *thanks Rupak Ganguly*
*   Update default scheme from http to https in the v1 auth. *thanks Rupak Ganguly*
*   Add uuid and links atrributes to the list servers mock. *thanks Rupak Ganguly*
*   Pass connection_options hash to the cdn connection in the storage provider. *thanks Rupak Ganguly*
*   Fix a bug where cdn state was not preserved. *thanks Rupak Ganguly*
*   Add helper method for cdn public ssl url and remove check for hp_cdn_ssl flag. *thanks Rupak Ganguly*
*   Add helper method for cdn public url for file. *thanks Rupak Ganguly*
*   Add helper method to get cdn ssl url for the files collection. *thanks Rupak Ganguly*
*   Add and enable get_console_output request method and add server method console_output. Add test for get_console_output. *thanks Rupak Ganguly*
*   Add avl zone as required param. Update endpoint retrieving logic from catalog to allow future avl zones. Fix minor error in tests. *thanks Rupak Ganguly*
*   Add avl zone as required param. Update endpoint retrieving logic from catalog to allow future avl zones. Fix minor error in tests. *thanks Rupak Ganguly*
*   Add availability zone required parameter for storage and cdn services. *thanks Rupak Ganguly*
*   Add availability zone required parameter for storage and cdn services. *thanks Rupak Ganguly*
*   Minor fix. *thanks Rupak Ganguly*
*   Add security_groups attribute to the server model. *thanks Rupak Ganguly*
*   Change hp_service_type to check for 'name' in the service catalog rather than 'type'. *thanks Rupak Ganguly*
*   Update tests to reflect addition of security_groups attribute to server model. *thanks Rupak Ganguly*
*   Update to not raise exception if service is not active or not present. *thanks Rupak Ganguly*
*   Upgrade to excon version 0.13.0 to take advantage of the ssl_verify_peer and ssl_ca_file params via the connection_options hash. Also, remove the use of :hp_servicenet setting for ssl for storage and compute providers. *thanks Rupak Ganguly*
*   Add request layer code for metadata. *thanks Rupak Ganguly*
*   Update mocking support for metadata to match real responses. *thanks Rupak Ganguly*
*   Add tests for metadata requests methods. *thanks Rupak Ganguly*
*   Minor fix to mocks. *thanks Rupak Ganguly*
*   Add metadata models support. Also, include metadata attribute in server and image models, to manage metadata. *thanks Rupak Ganguly*
*   Add some more metadata requests tests. *thanks Rupak Ganguly*
*   Minor fix and add a destroy method. *thanks Rupak Ganguly*
*   Add metadata tests for servers and images. *thanks Rupak Ganguly*
*   Fix code to metadata to the create image call. *thanks Rupak Ganguly*
*   Add an attribute for network_name to make it easy to switch. *thanks Rupak Ganguly*
*   Add a multi_json require so that json parsing is available. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Update call to include response_block rather than passing a block, to conform to excon deprecation message. *thanks Rupak Ganguly*
*   Add attributes to image model by extracting them from metadata. *thanks Rupak Ganguly*
*   Add a BlockStorage service to the HP provider. *thanks Rupak Ganguly*
*   Add list_volumes for block storage. *thanks Rupak Ganguly*
*   Add get_volume_details request method for block storage. *thanks Rupak Ganguly*
*   Add delete_volumes request method for block storage. *thanks Rupak Ganguly*
*   Add create_volume request method for block storage service. *thanks Rupak Ganguly*
*   Add ability to send in metadata to create_volume request method. *thanks Rupak Ganguly*
*   Fix mock for tests. *thanks Rupak Ganguly*
*   Fix typo in service folder. *thanks Rupak Ganguly*
*   Add the block storage service to the binary. *thanks Rupak Ganguly*
*   Fix mock for tests. *thanks Rupak Ganguly*
*   Add shindo tests for requests methods for block storage. *thanks Rupak Ganguly*
*   Add server attach block storage request methods. *thanks Rupak Ganguly*
*   Add list_server_volumes request method for block storage service. *thanks Rupak Ganguly*
*   Add attach_volume request method for block storage service. *thanks Rupak Ganguly*
*   Add detach_volume request method for block storage service. *thanks Rupak Ganguly*
*   Add shindo tests for server volume request methdos for block storage service. *thanks Rupak Ganguly*
*   Add volume model and volumes collection for block storage service. *thanks Rupak Ganguly*
*   Add shindo tests for volume models and collection. *thanks Rupak Ganguly*
*   Fix mock to provide correct status after creation. *thanks Rupak Ganguly*
*   Add a compute service attribute to peek into the compute service from within the block_storage service. *thanks Rupak Ganguly*
*   Add attach and detach methods to the volume model using the compute service attribute. *thanks Rupak Ganguly*
*   Add shindo tests for attach and detach. *thanks Rupak Ganguly*
*   Fix mock. Fix tests for mocking and real modes. *thanks Rupak Ganguly*
*   Add a head method for the directories collection. *thanks Rupak Ganguly*
*   Upgrade to excon 0.14.0 to take advantage of the new StandardInstrumentor for debug use. *thanks Rupak Ganguly*
*   Capture hp_auth_uri for passing down to compute provider. *thanks Rupak Ganguly*
*   Add a list_snapshot request method, a corresponding mock, and add support for it in the block storage provider. *thanks Rupak Ganguly*
*   Add a create_snapshot request method, a corresponding mock, and add support for it in the block storage provider. *thanks Rupak Ganguly*
*   Minor fix to the inline help. *thanks Rupak Ganguly*
*   Add a get_snapshot_details request method, a corresponding mock, and add support for it in the block storage provider. *thanks Rupak Ganguly*
*   Add a delete_snapshot request method, a corresponding mock, and add support for it in the block storage provider. *thanks Rupak Ganguly*
*   Add shindo tests for snapshots request layer methods. *thanks Rupak Ganguly*
*   Minor update to inline help. *thanks Rupak Ganguly*
*   Add snapshot model and collection to bloack storage provider. *thanks Rupak Ganguly*
*   Add snapshot model/collection and corresponding tests. *thanks Rupak Ganguly*
*   Add user_agent string to the core fog connection with corresponding tests. *thanks Rupak Ganguly*
*   Add customised user_agent string for HP providers. Also, enable passing a custom user_agent string from calling clients. Add corresponding tests. *thanks Rupak Ganguly*
*   Add volume_attachments to server model. *thanks Rupak Ganguly*
*   Bump version to 0.0.16 and update changelog. *thanks Rupak Ganguly*
*   Removed 'server' attribute from server model, and fixed 'all' method. *thanks Rupak Ganguly*
*   Removed 'images' attribute from server model. *thanks Rupak Ganguly*
*   Fix version info. that is used by user-agent. *thanks Rupak Ganguly*
*   Add object temp url generation capability with mock support. *thanks Rupak Ganguly*
*   Add object temp url functionality to file model layer. *thanks Rupak Ganguly*
*   Add request layer tests for object_temp_url functionality. *thanks Rupak Ganguly*
*   Add tenant_id to the mix to tighten security for the temp_url generation. *thanks Rupak Ganguly*
*   Update mock for tenp_url. *thanks Rupak Ganguly*
*   Call the request layer method instead of the generic util method. *thanks Rupak Ganguly*
*   Add model tests for storage service. *thanks Rupak Ganguly*
*   Add the request layer method to extract the windows password from the console log in case of a windows instance. *thanks Rupak Ganguly*
*   Update the server model with a method to retrieve the windows password. *thanks Rupak Ganguly*
*   Update the get_windows_password to return the encrypted password instead of the decrypted one. *thanks Rupak Ganguly*
*   Add grant, revoke and list methods for cross tenant object acls implementation. *thanks Rupak Ganguly*
*   Add request layer methods for shared container and shared object access. *thanks Rupak Ganguly*
*   Bump version and update changelog. *thanks Rupak Ganguly*
*   Fix response status for mocks. *thanks Rupak Ganguly*
*   Add mocks for shared container and objects calls. *thanks Rupak Ganguly*
*   Add a new exception class and handled exceptions in exception messages. *thanks Rupak Ganguly*
*   Add request method for put_shared_object. Add model and collection for shared_directory and shared_file. *thanks Rupak Ganguly*
*   Refactor common code into separate method. *thanks Rupak Ganguly*
*   Fix mock for put_container to reflect new acl changes. *thanks Rupak Ganguly*
*   Fix head call to return an empty body. *thanks Rupak Ganguly*
*   Removed comment. *thanks Rupak Ganguly*
*   Minor fix to allow options on save to pass in metadata. *thanks Rupak Ganguly*
*   Add method all. *thanks Rupak Ganguly*
*   Add methods for destroy and save. *thanks Rupak Ganguly*
*   Add method for destroy. *thanks Rupak Ganguly*
*   Add request layer method for put_shared_container. *thanks Rupak Ganguly*
*   Minor bug fix when acls are nil. Also, added support for specifying list of users for grant and revoke as a comma-separated list. *thanks Rupak Ganguly*
*   Allow the models to raise exception when there is insufficient access. *thanks Rupak Ganguly*
*   Add delete_shared_object and corresponding model support. *thanks Rupak Ganguly*
*   Update inline documentation. *thanks Rupak Ganguly*
*   Update method to remove availability_zone as input data parameter. *thanks Rupak Ganguly*
*   Allows creation of bootable volumes by passing in single part images. *thanks Rupak Ganguly*
*   Allows creation of server instances that use a bootable volume rather than an image as its base. This gives us persistant instances. *thanks Rupak Ganguly*
*   Fix failing shindo tests. *thanks Rupak Ganguly*
*   Fix some null checks. *thanks Rupak Ganguly*
*   Add request layer methods for listing and getting bootable volumes. *thanks Rupak Ganguly*
*   Update volume model and collection to handle bootable volumes as well. *thanks Rupak Ganguly*
*   Add code to accept config_drive and block_device_mapping parameters while creating a server instance. *thanks Rupak Ganguly*
*   Move CHANGELOG.hp under hp folder. *thanks Rupak Ganguly*
*   Bump the version and update the changelog. *thanks Rupak Ganguly*
*   Fix public_key attribute to be visible in table. *thanks Rupak Ganguly*
*   Add create_persistent_server request layer method to compute service. Add mocks and tests as well. *thanks Rupak Ganguly*
*   Remove block_device_mapping param from create_server request method call. *thanks Rupak Ganguly*
*   Add capability of creating regular and persistent servers via the server model. Make image_id an optional parameter for creating servers. *thanks Rupak Ganguly*
*   Add bootable_volumes collection for managing only bootable volumes. *thanks Rupak Ganguly*
*   Remove bootable volumes list and get methods and moved them under the bootable_volumes collection. *thanks Rupak Ganguly*
*   Update changelog and release date. *thanks Rupak Ganguly*
*   Updated the BlockStorage namespace to be Fog::HP::BlockStorage. *thanks Rupak Ganguly*
*   Updated the tests to reflect the BlockStorage namespace changes. *thanks Rupak Ganguly*
*   Fix case where invalid CDN endpoint was causing issues. *thanks Rupak Ganguly*
*   Update to new code and tests based on changes from upstream fog. *thanks Rupak Ganguly*
*   Deprecate hp_account_id to use hp_access_key instead. *thanks Rupak Ganguly*
*   Fix fog.gemspec. *thanks Rupak Ganguly*
*   * [dreamhost|dns] initial import. *thanks Sergio Rubio*
*   Switch gem source to https://rubygems.org. *thanks Sergio Rubio*
*   A whitespace fix :v:. *thanks Simon Gate*
*   add install.txt. *thanks Terry Howe*
*   remove file. *thanks Terry Howe*
*   Update put_object to accept blocks, and remove deprecation message. *thanks Terry Howe*
*   Fix warning. *thanks William Lawson*
*   version. *thanks William Lawson*
*   reverse version change. *thanks William Lawson*
*   joyent resize smartmachine incorrect class type. *thanks angus*
*   Typo in instantiate_vapp_template.rb. *thanks dJason*
*   fix for user agent tests excon usage. *thanks geemus*
*   fixed bug, quantum api need no underscore valiable name. (ex floatingips. *thanks kanetann*
*   Update lib/fog/ecloud/requests/compute/virtual_machine_create_from_template.rb. *thanks tipt0e*
*   Fog::Vsphere::Compute - misspelled method 'get_vm_by_ref' in vm_reconfig_hardware. *thanks tipt0e*

#### [openstack]
*   Register the image service. *thanks Anshul Khandelwal*
*   string interpolation problem image create fixes #1493. *thanks Ruben Koster*

#### [openstack|compute]
*   fix get_metadata call. *thanks Ben Bleything*
*   rename meta_hash to to_hash; make it public. *thanks Ben Bleything*
*   adds methods to retireve floating & fixed ip addresses. *thanks Ohad Levy*
*   ensures we clear ipaddresses cache upload reload. *thanks Ohad Levy*
*   configurable :openstack_endpoint_type. *thanks Sergio Rubio*
*   images collection should not return nil for #all. *thanks Sergio Rubio*

#### [openstack|identity]
*   Marks test as pending. *thanks Paul Thornthwaite*
*   Configurable :openstack_endpoint_type. *thanks Sergio Rubio*
*   user model tests fixes. *thanks Sergio Rubio*
*   cleanup the test role when no longer in use. *thanks Sergio Rubio*

#### [openstack|network]
*   Added missing Network model attributes. *thanks Sergio Rubio*

#### [openstack|storage]
*   intial import. *thanks Sergio Rubio*
*   added OpenStack Storage to lib/fog/storage.rb. *thanks Sergio Rubio*
*   Added OpenStack.escape utility method. *thanks Sergio Rubio*
*   Added storage service to lib/fog/bin/openstack.rb. *thanks Sergio Rubio*
*   Added OpenStack Storage service tests. *thanks Sergio Rubio*
*   configurable service_type and service_name. *thanks Sergio Rubio*
*   added openstack_tenant and openstack_region params. *thanks Sergio Rubio*
*   replace 'object_store' service type with 'object-store'. *thanks Sergio Rubio*

#### [openstack|volume]
*   Configurable :openstack_endpoint_type. *thanks Sergio Rubio*
*   remove extra comma. *thanks Sergio Rubio*
*   Added missing service declaration. *thanks Sergio Rubio*

#### [ovirt]
*   Add support for reading the oVirt api version. *thanks Amos Benari*
*   Added support for oVirt volume status. *thanks Amos Benari*
*   Updated the blocking start logic to fit oVirt 3.1 api. *thanks Amos Benari*

#### [rackspace]
*   adding accept headers to block_storage, cdn, compute_v2, databases, identity, load_balancers, storage. *thanks Kyle Rames*
*   fixing merge. *thanks Kyle Rames*

#### [rackspace|cdn]
*   implemented purge object from CDN; added CDN tests and mocks. *thanks Kyle Rames*
*   more refactoring. *thanks Kyle Rames*
*   more refactoring of cdn. *thanks Kyle Rames*

#### [rackspace|compute]
*   Fix typo in attachments model. *thanks Brad Gignac*
*   Handle malformed API responses. *thanks Brad Gignac*
*   Update server to use default networks. *thanks Brad Gignac*
*   Allow custom network on server. *thanks Brad Gignac*
*   this should address a metadata issue discovered in chef http://tickets.opscode.com/browse/KNIFE-217. *thanks Kyle Rames*
*   this should address a metadata issue discovered in chef http://tickets.opscode.com/browse/KNIFE-217(cherry picked from commit a859b9ecf550469ac43ea35402785dad59d7c7f2). *thanks Kyle Rames*
*   added create server example. *thanks Kyle Rames*
*   Adding more cloud server examples. *thanks Kyle Rames*
*   tweaking examples. *thanks Kyle Rames*
*   fixing typo in metadata class. *thanks Kyle Rames*
*   fixing connection deprecation warnings. *thanks Kyle Rames*
*   Adding API documentation. *thanks Kyle Rames*
*   updated to check for public_ip_address instead of ip4_address as setup uses the public_ip_address. *thanks Kyle Rames*
*   removed timeout from bootstrap method signature and hard coded it in method per geemus. *thanks Kyle Rames*
*   added test for put_container with an optional parameter. *thanks Kyle Rames*
*   updated mocking framework to support any flavor or image. *thanks Kyle Rames*
*   remove erroneous block argument to get_object     fixes #1588. *thanks geemus*

#### [rackspace|compute_v2]
*   fixing merge issues; added metadata test for servers. *thanks Kyle Rames*
*   Added note indicating that RackConnect users should use Server personalization rather than the bootstrap method. *thanks Kyle Rames*
*   fixing bootstrap example. *thanks Kyle Rames*
*   compute_v2 tests were failing because the flavor used in the tests was too small for the image selected. I updating tests to use the an Ubuntu image in hopes of making the tests less brittle. *thanks Kyle Rames*

#### [rackspace|database]
*   remove extraneous colon. *thanks Kyle Rames*

#### [rackspace|databases]
*   removed trailing stash from hard coded endpoints; added accept header. *thanks Kyle Rames*

#### [rackspace|dns]
*   added tests for zones.find. *thanks Brian Hartsock*
*   fix issue in zones.find where results with no links throw exception. *thanks Brian Hartsock*

#### [rackspace|identity]
*   Correctly populate model from request data. *thanks Brad Gignac*
*   Remove unused get_credentials request. *thanks Brad Gignac*

#### [rackspace|lb]
*   fixed issue where double paths cause API errors. *thanks Brian Hartsock*
*   removed puts. *thanks Brian Hartsock*

#### [rackspace|networks]
*   Add Cloud Networks requests. *thanks Brad Gignac*
*   Add networks model and collection. *thanks Brad Gignac*
*   Add mock responses. *thanks Brad Gignac*

#### [rackspace|storage]
*   refactored storage/cdn. *thanks Kyle Rames*
*   fixed issue in ruby 1.8.7 where metadata was not being deleted when set to nil. *thanks Kyle Rames*
*   tweaked directory implementation; added directory model tests. *thanks Kyle Rames*
*   updating to return true after saving directory. *thanks Kyle Rames*
*   added support for container metadata; added directory tests. *thanks Kyle Rames*
*   Cloud Files will not process a header without a value so I added a stand in value for nil. *thanks Kyle Rames*
*   added delete method to metadata. *thanks Kyle Rames*
*   removing test of dubious distinction per geemus. *thanks Kyle Rames*
*   updated file class to use the same metadata implementation as the directory class. *thanks Kyle Rames*
*   added test to check for metadata on object creation; tweaked metadata on object creation test. *thanks Kyle Rames*
*   updated metadata class to decode incoming header values using FOG::JSON. *thanks Kyle Rames*
*   fixing Metadata#respond_to? method. *thanks Kyle Rames*
*   updated directory to lazy load metadata when necessary. *thanks Kyle Rames*
*   added tests for metadata class; fixed bug with method missing. *thanks Kyle Rames*
*   updated file class to use the same metadata implementation as the directory class. *thanks Kyle Rames*
*   added test to check for metadata on object creation; tweaked metadata on object creation test. *thanks Kyle Rames*
*   updated metadata class to decode incoming header values using FOG::JSON. *thanks Kyle Rames*
*   rebased with dir_metadata branch - https://github.com/fog/fog/pull/1563. *thanks Kyle Rames*
*   added ios_url and streaming_url methods to directory and file; added more tests. *thanks Kyle Rames*
*   added account model. *thanks Kyle Rames*
*   removing type conversion for metadata per https://github.com/fog/fog/pull/1587. *thanks Kyle Rames*
*   added the ability to determine meta prefixes from Class objects as well as Fog object. This addresses issue in Files#get method. *thanks Kyle Rames*

#### [tests]
*   Updates format tests. *thanks Paul Thornthwaite*
*   Changes to format testing helper. *thanks Paul Thornthwaite*
*   Extracts schema validator to class. *thanks Paul Thornthwaite*
*   Fixes schema validator for arrays. *thanks Paul Thornthwaite*

#### [virtualbox]
*   Removed VirtualBox since it has many problems and the gem it's based on is no longer maintained. *thanks Kevin Menard*


## 1.9.0 01/19/2013
*Hash* 0283cac581edc36fe58681c51d6fa2a5d2db3f41

Statistic     | Value
------------- | --------:
Collaborators | 41
Downloads     | 1567112
Forks         | 673
Open Issues   | 99
Watchers      | 2342

**MVP!** Paul Thornthwaite

#### [AWS]
*   CopySnapshot. supports cross-region snapshot copying. *thanks Shai Rosenfeld & Jacob Burkhart*

#### [AWS|DynamoDB]
*   Default to HTTPS. *thanks Blake Gentry*

#### [AWS|cloud_watch]
*   Add Metrics#each, which follows NextToken. *thanks Michael Hale*

#### [Brightbox]
*   Add ServerGroup attribute in CloudIP model. *thanks Hemant Kumar*
*   Guards against unimplemented mock. *thanks Paul Thornthwaite*
*   Adds firewall request tests. *thanks Paul Thornthwaite*
*   Deprecates incorrect form of #request. *thanks Paul Thornthwaite*
*   Replaces usage of deprecated #request. *thanks Paul Thornthwaite*
*   Adds #dns_name to server. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [Rackspace]
*   updated to select London athorization endpoint if the London Region endpoint is selected. *thanks Kyle Rames*

#### [Rackspace|Compute]
*   updated create_image to return an image object instead of the object id. *thanks Kyle Rames*
*   updated ready method on Image to raise an exception if an error state occurs. This is similar to the behavior of Server. *thanks Kyle Rames*

#### [atmos]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws]
*   Replaces #new_record? with #persisted?. *thanks Paul Thornthwaite*

#### [aws|auto_scaling]
*   Implement resume_processes mock. *thanks Michael Hale*
*   Implement suspend_processes mock. *thanks Michael Hale*
*   remove pending if mocking? for model_tests. *thanks Michael Hale*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|beanstalk]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|cdn]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|cloud_watch]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|compute]
*   Updates 'connection' references. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|dns]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|elasticache]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|elb]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|glacier]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|iam]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|rds]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [aws|storage]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [bluebox]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [clodo]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [cloudstack]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [core]
*   Adds #persisted? to Fog models. *thanks Paul Thornthwaite*
*   Breaks down rake tasks. *thanks Paul Thornthwaite*
*   Deprecates 'connection' accessor. *thanks Paul Thornthwaite*
*   Fix service instance variable being included when doing     model.to_json. *thanks Philip Mark M. Deazeta*

#### [dns_made_easy|dns]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [dnsimple]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [doc]
*   converting old doc style to YARD doc style. *thanks Weston Platter*
*   is there a better way to format nested responses?. *thanks Weston Platter*

#### [docs]
*   changed rdoc formatting to yard. *thanks Danny Garcia*
*   Creates release policy document to discuss. *thanks Paul Thornthwaite*

#### [docs::aws::storage]
*   added [] to make it pretty. *thanks Weston Platter*
*   yard doc syntax fix. *thanks Weston Platter*
*   reformatted copy_object. *thanks Weston Platter*
*   reformatted delete requests. *thanks Weston Platter*
*   standardized return format       for key with values,         # `@return` variable [data_type]:       for values,         # * variable [data_type] - description of value. *thanks Weston Platter*
*   WIP on get requests. *thanks Weston Platter*
*   finished formatting get requests. *thanks Weston Platter*
*   requests convert Rdoc to YARD format. *thanks Weston Platter*
*   requests minor tweaks to keep docs all the same. *thanks Weston Platter*
*   requests changed Rdoc to YARD. *thanks Weston Platter*
*   requests finished changing RDoc to Yard. *thanks Weston Platter*
*   remove 1 space char for formatting. *thanks Weston Platter*

#### [docs::was::storage]
*   i was wrong. this is an int describing "number of seconds before expiration"     to confirm, go to -- http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectPUT.html     search for -- expires. *thanks Weston Platter*
*   formatting. *thanks Weston Platter*
*   added more description. *thanks Weston Platter*
*   added docs for other public methods. *thanks Weston Platter*
*   added URL for list of S3 docs about Restful HTTP API. *thanks Weston Platter*
*   this consistently spaces all methods 2 lines from each other. *thanks Weston Platter*

#### [dynect|dns]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [ecloud]
*   improvements and some mocking. *thanks Eugene Howe & Josh Lane*
*   Replaces #new_record? with #persisted?. *thanks Paul Thornthwaite*
*   Fixes tests by duplicating test setup. *thanks Paul Thornthwaite*

#### [ecloud|compute]
*   Fixes missing value. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*
*   Fixes tagging of some tests. *thanks Paul Thornthwaite*
*   Fixes ecloud server tests. *thanks Paul Thornthwaite*

#### [glesys|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [go_grid|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [google|storage]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [hp]
*   Replaces #new_record? with #persisted?. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [ibm]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [joyent|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [libvirt|compute]
*   Updates 'connection' references. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [linode]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [local|storage]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [misc]
*   use old multijson methods. *thanks Carl Allen*
*   always use old encode/decode from multijson (it only has warnings in 1.3.0-1.3.2). *thanks Carl Allen*
*   Rackspace, openstack, hp API error messages are not set correctly in exceptions. *thanks Carlos Sanchez*
*   Add vsphere public_ip_address correctly. *thanks Carlos Sanchez*
*   add failing test and update Mock list_users to filter based on tenant_id. *thanks Coby Randquist*
*   update tenant.rb to pass the test, by passing correct parameter. *thanks Coby Randquist*
*   OpenStack server test updates for real mode. *thanks Dan Prince*
*   OpenStack: Drop unused server_format hash. *thanks Dan Prince*
*   OpenStack custom exception cleanup. *thanks Dan Prince*
*   OpenStack auth updates to select by service name. *thanks Dan Prince*
*   skype sucks. *thanks Danny Garcia*
*   change copy_object docs to YARD. *thanks Danny Garcia*
*   YARD docs for head_object.rb. *thanks Danny Garcia*
*   how do I updates my clone with updates from source?. *thanks Danny Garcia*
*   change docs on initiate_multipart_upload.rb. *thanks Danny Garcia*
*   change copy_object docs to YARD. *thanks Danny Garcia*
*   YARD docs for head_object.rb. *thanks Danny Garcia*
*   how do I updates my clone with updates from source?. *thanks Danny Garcia*
*   change docs on initiate_multipart_upload.rb. *thanks Danny Garcia*
*   resolve merge conflicts according to the code on fog master. *thanks Danny Garcia*
*   change doc on copy_object.rb. *thanks Danny Garcia*
*   change docs. *thanks Danny Garcia*
*   Add ability to specify Tags to AWS cfn-create-stack call. *thanks David Chen*
*   Remove tabs... *thanks David Chen*
*   Added test for Fog::Openstack::authenticate_v2. *thanks Eric Hodel*
*   Raise a NotFound exception for missing services. *thanks Eric Hodel*
*   Add OpenStack EC2 credentials requests. *thanks Eric Hodel*
*   Added OpenStack EC2 credential management models. *thanks Eric Hodel*
*   Added documentation for OS-EC2 requests. *thanks Eric Hodel*
*   Ruby 1.8.7 does not allow trailing commas in method arguments. *thanks Eric Hodel*
*   Ruby 1.8.7 does not allow trailing commas in method arguments (for remaining files). *thanks Eric Hodel*
*   OpenStack create_server mocks now match reality. *thanks Eric Hodel*
*   Added mock for Fog::Identity#get_user_by_name. *thanks Eric Hodel*
*   Removed extra whitespace from previous commit. *thanks Eric Hodel*
*   Store the user_id in the server mock data. *thanks Eric Hodel*
*   Added SIGINT handler to the fog console. *thanks Eric Hodel*
*   OpenStack servers can now retrieve security groups. *thanks Eric Hodel*
*   adds support for bucket transitioning/fixes bucket lifecycle management. *thanks Eric Stonfer*
*   fixed bug where Fog::Storage::Rackspace::File raised Fog::Storage::Rackspace::NotFound if file was created with passed etag attribute. Changed to check existence based on last_modified instead of etag. *thanks Evan Smith*
*   Added multi-region support for OpenStack Image service. *thanks Joe Topjian*
*   use CGI.escapeHTML instead of CGI.escape. *thanks John Parker*
*   Correct the Blue Box create_block method to check for ssh_public_key, not public_key. *thanks Josh Kalderimis*
*   Correct the docs for the ssh_public_key option. *thanks Josh Kalderimis*
*   added create_image and delete_image to Compute::RackspaceV2 Fixes #1351. *thanks Kyle Rames*
*   added a mock for Compute::RackspaceV2 delete_image; Compute::RackspaceV2 has not implemented mocking support however. *thanks Kyle Rames*
*   Updated Fog.wait_for to throw a timeout exception instead of returning false #1368. *thanks Kyle Rames*
*   updating wait_for timeout message per conversation with `@geemus.` *thanks Kyle Rames*
*   Modified Fog::Compute::RackspaceV2 destroy image test from test setup. *thanks Kyle Rames*
*   Updated Fog::Rackspace::Errors::Service error to include the HTTP response code to aid in debugging. *thanks Kyle Rames*
*   Fixing html escape typo in the Rackspace section of the Fog storage instructions. *thanks Kyle Rames*
*   added create_snapshot method to Fog::Rackspace::BlockStorage::Volume. *thanks Kyle Rames*
*   updated save method in Fog::Rackspace::BlockStorage::Volume and Fog::Rackspace::BlockStorage::Snapshot to skip creating cloud reources if identity was already set Fixes #1402. *thanks Kyle Rames*
*   Updated default Rackspace Compute provider to return a Fog::Compute::RackspaceV2 instance. In order to access legacy Cloud Servers, a :version => :v1 parameter will need be passed like so Fog::Compute.new({       :provider                 => 'Rackspace',       :rackspace_username        => USER,       :rackspace_api_key    => API_KEY,       :version => :v1     }). *thanks Kyle Rames*
*   Updated the save method in Fog::Rackspace::BlockStorage::Volume and Fog::Rackspace::BlockStorage::Snapshot to throw an exception if the identity attribute is set per geemus; rebased code to latest master. *thanks Kyle Rames*
*   updating Compute[:rackspace] to use v1 provider. *thanks Kyle Rames*
*   Updated compute model tests to take a provider parameter; Updated tests to run tests for Rackspace Compute V1. I will add V2 when the mocks are complete. *thanks Kyle Rames*
*   reverted back to version 1 of the Rackspace compute interface along with a deprecation warning. *thanks Kyle Rames*
*   implemented list_addresses for Fog::Compute::RackspaceV2. *thanks Kyle Rames*
*   implemented list_addresses_by_network for Fog::Compute::RackspaceV2. *thanks Kyle Rames*
*   added server metadata operations for Fog::Compute::RackspaceV2. *thanks Kyle Rames*
*   refactored Fog::Compute::RackspaceV2 metadata to take collection as a parameter rather than using it as part of the method name. *thanks Kyle Rames*
*   fixing broken metadata tests. *thanks Kyle Rames*
*   changed metadata implementation for Fog::Compute::RackspaceV2::Server and Fog::Compute::RackspaceV2::Image. *thanks Kyle Rames*
*   changing variable names to make code clearer. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   added better acceptance criteria to server/image metadata tests; added metadata to ignored_attributes to address bug. *thanks Kyle Rames*
*   fixing merge issues with master. *thanks Kyle Rames*
*   fixing typo. *thanks Kyle Rames*
*   fixing broken tests. *thanks Kyle Rames*
*   tweaking tests and error handling. *thanks Kyle Rames*
*   merge in latest master. *thanks Kyle Rames*
*   Updated Fog::Logger to log to standard out if DEBUG=true is passed in through the environment. *thanks Kyle Rames*
*   Fixing merge conflicts. *thanks Kyle Rames*
*   fixing merge issues. *thanks Kyle Rames*
*   tweaking whitespace in order to get travis to rebuild. *thanks Kyle Rames*
*   tweaking whitespace one more time in order to get travis to rebuild. *thanks Kyle Rames*
*   initial revision of rackspace documentation. *thanks Kyle Rames*
*   Support AWS S3 cors configuration for buckets. *thanks Lee Henson*
*   adding support for rackspace loadbalancer content caching. *thanks Luiz Ribeiro*
*   Added request create_folder for vsphere compute. This will create a vm folder in vsphere. *thanks Matthew Black*
*   Expanded vm_clone to allow for setting up static ip for first nic. *thanks Matthew Black*
*   Add Gem Version badge. *thanks Michael Rykov*
*   Added new output to vm_clone.rb     Fixed 'path' attribute on server model     fixed server.clone function and added some documentation. *thanks Nick Huanca*
*   Fixed path for folder attribute model. *thanks Nick Huanca*
*   Added a new attribute to server model (relative_path)     cleaned up clone function from server model     Added better use of resource pool, dest_folder     Added new datastore selection, simplified vm_clone.rb     Added Customization specs for linux machines     Added a new call from datacenters method to grab virtual_servers in datacenter. *thanks Nick Huanca*
*   fixed up issues with vm_clone looking for methods that didn't exist     tested with wait => true,     wait => false fails since it cannot load model while server is still being created. *thanks Nick Huanca*
*   added styling fix. *thanks Nick Huanca*
*   Fixed up tests. *thanks Nick Huanca*
*   fixed up some issues with the tests, needs more work and thought. *thanks Nick Huanca*
*   added a note about ugliness and needing more help with tests. *thanks Nick Huanca*
*   Adds badge for dependencies status. *thanks Paul Thornthwaite*
*   Make use of #persisted? method. *thanks Paul Thornthwaite*
*   Removes tags file from repo. *thanks Paul Thornthwaite*
*   Revert "add GitHub Flavored Markdown to README". *thanks Paul Thornthwaite*
*   add GitHub Flavored Markdown to README. *thanks Phil Cohen*
*   Fix typo and use #get_header to handle mixed-case header keys. *thanks Rida Al Barazi*
*   Adding describe_reserved_cache_nodes.rb     '     '. *thanks Sean Hart*
*   Added Tests for Elasticache Reservations. *thanks Sean Hart*
*   Added missing HostMetrics model. *thanks Sergio Rubio*
*   Added some task descriptions so they show up with 'rake -T'. *thanks Sergio Rubio*
*   Alias 'rake build' task with 'rake gem'. *thanks Sergio Rubio*
*   Introduce AWS::COMPLIANT_BUCKET_NAMES constant. *thanks Stephan Kaag*
*   fix typo. *thanks Steve Agalloco*
*   list all VMs in nested folders. *thanks Tejas Ravindra Mandke*
*   search through all network adapters recursively to find one being searched for. *thanks Tejas Ravindra Mandke*
*   a few workarounds allowing aws plugin to work with Eucalyptus cloud. *thanks Tomasz Bak*
*   unit test for the XML namespace handling workaround. *thanks Tomasz Bak*
*   a workaround for lack of handling XML namespaces directly (required by Eucalyptus endpoint). *thanks Tomasz Bak*
*   add IamInstanceProfile abilitie. *thanks Topper Bowers*
*   fix existing spot specs. *thanks Topper Bowers*
*   support parsing the iamInstanceProfile. *thanks Topper Bowers*
*   Properly return all alarms. *thanks Trotter Cashion*
*   add aws page - wip #1350. *thanks Weston Platter*
*   work in progress #1350 - change tabs to spaces. *thanks Weston Platter*
*   complete #1350 add link to index page referencing storage/aws.hmtl. *thanks Weston Platter*
*   issue/1350 [doc] add options param. *thanks Weston Platter*
*   issue/1350 [doc] add key to options hash -- encryption. *thanks Weston Platter*
*   issue/1350 [doc] add other key to options hash. *thanks Weston Platter*
*   Added a cors (with bucket) item to the data has of the Storage AWS Mock class (upon creation of the hash). This is to prevent put_bucket_cors from failing during tests. *thanks epdejager*
*   Added a test for put_bucket_cors to make sure it runs in a test (mock) scenario. *thanks epdejager*
*   remove docs and related, they now live at fog/fog.github.com. *thanks geemus*
*   update copyright notice year. *thanks geemus*
*   rescue/retry when loading gems (possibly without rubygems)     closes #901. *thanks geemus*
*   added floatingip. *thanks kanetann*
*   added associate_floatingip and disassosiate_floatingip mock test. *thanks kanetann*
*   update associate_floatingip for real. *thanks kanetann*
*   deleted update_floatingip and changed variable name from floating_network_id to floatingip_id. *thanks kanetann*
*   fixed disassociate_floatingip bug and update floatingip-* mock values. *thanks kanetann*
*   updated for ruby naming conventions. *thanks kanetann*
*   deleted old files eg. floatingip.rb. *thanks kanetann*
*   Bug fix: Ensure Fog::VERSION gets defined. *thanks ronen barzel*
*   remove const_defined? guard. *thanks ronen barzel*

#### [ninefold|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [openstack]
*   Show an error message when there aren't any endpoints available for a region. *thanks Ferran Rodenas*
*   Show an error message when there aren't any endpoints available for a region. *thanks Ferran Rodenas*
*   Update Mocks and Cleanup Unused Code. *thanks Nelvin Driz*
*   Fix Test. *thanks Nelvin Driz*
*   Replaces #new_record? with #persisted?. *thanks Paul Thornthwaite*
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [openstack|compute]
*   Update Quota Mocks based on Folsom Stable. *thanks Nelvin Driz*

#### [openstack|identity]
*   Update User Role Membership Mocks. *thanks Nelvin Driz*
*   Added sample code to README.identity.md. *thanks Sergio Rubio*
*   replace to_json with Fog::JSON.encode. *thanks Sergio Rubio*

#### [openstack|image]
*   Fixes #1383. *thanks Sergio Rubio*
*   Configurable :openstack_endpoint_type. *thanks Sergio Rubio*

#### [ovirt|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [rackspace]
*   compute_v2 and blockstorage are mocked     [ecloud] fixed a test and removed connection deprecation notices. *thanks Eugene Howe*
*   Moved methods to MockData module. *thanks Eugene Howe*
*   updated Rackspace to return a list of all services. *thanks Kyle Rames*
*   Updates reference to service. *thanks Paul Thornthwaite*
*   Fixes nesting of tests. *thanks Paul Thornthwaite*

#### [rackspace|compute]
*   updated rebuild to support passing additional options. *thanks Kyle Rames*
*   added attach_volume method to server; cleaned up attachment model. *thanks Kyle Rames*
*   server update method now updates accessIPv4, accessIPv6, as well as name; made server request tests more robust. *thanks Kyle Rames*
*   made device an optional parameter in attach_volume method and request; split volume_attach and attachments into two different tests. *thanks Kyle Rames*
*   tweaked server model tests; updated ready? method to support different ready states as well as checking for error states. *thanks Kyle Rames*

#### [rackspace|dns]
*   creating a record now uses specified ttl. *thanks Andreas Gerauer*

#### [rackspace|storage]
*   Updates 'connection' references. *thanks Paul Thornthwaite*

#### [serverlove|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [storm_on_demand]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [terremark]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [vcloud]
*   Replaces #new_record? with #persisted?. *thanks Paul Thornthwaite*

#### [vcloud|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [virtual_box|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [vmfusion]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [voxel|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*

#### [vsphere]
*   allow to create a vm with multiple disks. *thanks Ohad Levy*

#### [vsphere|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*
*   Reverts change of connection. *thanks Paul Thornthwaite*

#### [xenserver]
*   Fix Fog::XenServer::Connection.authenticate. *thanks Oguz Bilgic*
*   Added HostMetrics tests. *thanks Sergio Rubio*
*   added create_sr request (create Storage Repository). *thanks Sergio Rubio*
*   added destroy_sr request (destroy Storage Repository). *thanks Sergio Rubio*
*   added unplug_pbd request. *thanks Sergio Rubio*
*   added new requests to compute service. *thanks Sergio Rubio*
*   added unplug method to PBD model. *thanks Sergio Rubio*
*   missing Pool model attribute, new methods. *thanks Sergio Rubio*
*   added new methods to StorageRepository model. *thanks Sergio Rubio*
*   updated create_sr request documentation, fixed default values. *thanks Sergio Rubio*
*   add missing PBD 'currently_attached' attribute. *thanks Sergio Rubio*
*   StorageRepository.save should use sane defaults. *thanks Sergio Rubio*
*   add missing host operations (enable/disable, reboot, shutdown). *thanks Sergio Rubio*
*   added missing HostCpu model. *thanks Sergio Rubio*
*   added missing host_cpus attribute to Host model. *thanks Sergio Rubio*
*   add missing Host attributes (edition, software_version). *thanks Sergio Rubio*
*   replace #connection with #service in models. *thanks Sergio Rubio*
*   Use Nokogiri instead of slow REXML for parsing. *thanks deepj*

#### [xenserver|compute]
*   Updates reference to service. *thanks Paul Thornthwaite*
*   added getting started examples. *thanks Sergio Rubio*

#### [xenserver|docs]
*   Added maintainer/attribution header to README.md. *thanks Sergio Rubio*
*   added creating_servers.md tutorial. *thanks Sergio Rubio*
*   added storage repositories examples. *thanks Sergio Rubio*
*   added some color!, minor format fixes. *thanks Sergio Rubio*
*   Added new example that covers a Citrix KB ctx116324 article. *thanks Sergio Rubio*
*   Added XenServer provider specific ChangeLog. *thanks Sergio Rubio*

#### [xenserver|tests]
*   Added create_sr request tests. *thanks Sergio Rubio*
*   Added destroy_sr request tests. *thanks Sergio Rubio*
*   add unplug_pbd request tests. *thanks Sergio Rubio*
*   tests PBDs plug/unplug operation. *thanks Sergio Rubio*
*   added more pool tests to cover the new functionality. *thanks Sergio Rubio*
*   added missing SotorageRepository tests. *thanks Sergio Rubio*
*   added HostCpu model tests. *thanks Sergio Rubio*
*   typo fix. *thanks Sergio Rubio*
*   test Host.host_cpus method. *thanks Sergio Rubio*

#### [zerigo|dns]
*   Updates reference to service. *thanks Paul Thornthwaite*


## 1.8.0 12/01/2012
*Hash* 057c0c525a39e77cb2037c9fec3d851b209c151b

Statistic     | Value
------------- | --------:
Collaborators | 41
Downloads     | 1334733
Forks         | 630
Open Issues   | 98
Watchers      | 2258

#### [AWS]
*   Adds ModifyVolumeAttribute. *thanks Eric Stonfer*

#### [Brightbox]
*   Removes incorrect yard tag. *thanks Paul Thornthwaite*
*   Updates request docs to use Yard. *thanks Paul Thornthwaite*
*   Adds baseline documentation. *thanks Paul Thornthwaite*
*   Documents #request method. *thanks Paul Thornthwaite*
*   Comments out rogue text. *thanks Paul Thornthwaite*
*   Fixes generated files EOF with newlines. *thanks Paul Thornthwaite*
*   Adds Servers#bootstrap. *thanks Paul Thornthwaite*
*   Adds way to check auth method. *thanks Paul Thornthwaite*
*   Adds reset FTP for scoped accounts. *thanks Paul Thornthwaite*
*   Fixes Compute#account to pass service. *thanks Paul Thornthwaite*
*   Fixes Account#reset_ftp_password. *thanks Paul Thornthwaite*
*   Fixes test to run out of sequence. *thanks Paul Thornthwaite*
*   Expands documentation for Compute class. *thanks Paul Thornthwaite*
*   Tests recognised options. *thanks Paul Thornthwaite*
*   Refactors credential code in Compute. *thanks Paul Thornthwaite*
*   Extracts authentication connection. *thanks Paul Thornthwaite*
*   Refactors how tokens are requested. *thanks Paul Thornthwaite*
*   Moves tokens to CredentialSet. *thanks Paul Thornthwaite*
*   Extracts parts of request out of compute. *thanks Paul Thornthwaite*
*   Adds support for refresh tokens. *thanks Paul Thornthwaite*
*   Adds option to disable token management. *thanks Paul Thornthwaite*
*   Adds means to update scoped account. *thanks Paul Thornthwaite*
*   Moves more of public API into Shared. *thanks Paul Thornthwaite*
*   Guards unimplemented mock tests. *thanks Paul Thornthwaite*

#### [Docs]
*   Switches to using Yard for documentation. *thanks Paul Thornthwaite*

#### [aws]
*   fixed auto scaling model group 'destroy' method where it needs to use merge! instead of merge to set the opts local variable in place,  otherwise the options passed to the method are droppedon the floor. *thanks Jay Perry*

#### [aws|compute]
*   add offeringType to output from describe_reserved_instances_offerings. *thanks geemus*
*   fix mocks/tests around describe_reserved_instances_offerings. *thanks geemus*
*   fix one more offeringType mock format test failure. *thanks geemus*

#### [aws|dynamodb]
*   port off of sts for credentials, now uses signature v4. *thanks geemus*

#### [aws|storage]
*   Add Fog::Storage::AWS#delete_multiple_objects. *thanks Garret Alfert*
*   Add mock for Fog::Storage::AWS#delete_multiple_objects. *thanks Garret Alfert*
*   Little improvements to delete_multiple_objects tests. *thanks Garret Alfert*
*   Add Fog::Storage::AWS#delete_multiple_objects. *thanks Garret Alfert*
*   Add mock for Fog::Storage::AWS#delete_multiple_objects. *thanks Garret Alfert*
*   Little improvements to delete_multiple_objects tests. *thanks Garret Alfert*

#### [core]
*   Adds fog User-Agent header. *thanks Paul Thornthwaite*
*   Splits Fog::VERSION into own file. *thanks Paul Thornthwaite*
*   Adds fog User-Agent header. *thanks Paul Thornthwaite*
*   Updates Rakefile to use Fog::VERSION. *thanks Paul Thornthwaite*

#### [dns]
*   Add more record tests. *thanks Brian Hartsock*

#### [docs]
*   Updates link on fog.io to point to doc. *thanks Paul Thornthwaite*
*   Updates contributing notes. *thanks Paul Thornthwaite*
*   Replaces link to API to `rubydoc.info`. *thanks Paul Thornthwaite*
*   Adds 1.8.7 note to fog.io collaborators guide. *thanks Paul Thornthwaite*

#### [misc]
*   Add support for AWS Australia (ap-southeast-2). *thanks Amy Woodward*
*   Add Hosted Zone ID for ap-southeast-2. *thanks Amy Woodward*
*   Do not add empty security group. *thanks Dan Bode*
*   Add attr group. *thanks Dan Bode*
*   Sync with latest OpenStack flavors extensions. *thanks Dan Prince*
*   OpenStack floating_ip (aka address) test fixes. *thanks Dan Prince*
*   OpenStack: Remove volumes from limits tests. *thanks Dan Prince*
*   OpenStack: updates to quota tests. *thanks Dan Prince*
*   OpenStack: security group test fixes. *thanks Dan Prince*
*   add support for Storage::Rackspace::File#access_control_allow_origin and #origin. *thanks Dusty Jones*
*   add support for Storage::Rackspace::File#access_control_allow_origin and #origin. *thanks Dusty Jones*
*   Save the file instance before testing for presence of attribute. *thanks Dusty Jones*
*   Fix describe_instances stateReason handling. *thanks Edward Muller*
*   added support for Storage::Rackspace::File#metadata. *thanks Evan Smith*
*   added support for Storage::Rackspace::File#metadata. *thanks Evan Smith*
*   merged with origin. *thanks Evan Smith*
*   Rackspace Cloud Files. can load metadata from existing file. can set metadata for new file. can unset metadata for existing file. *thanks Evan Smith*
*   merged with upstream master. *thanks Evan Smith*
*   Implemented bootstrap method for Rackspace Compute v2.     Added ability to set "metadata" and "personality" fields when creating a server on Rackspace Compute v2.     Improved response parsing when dealing with Rackspace DNS service. *thanks Jesse Scott*
*   Removed the commented out password setting line for Rackspace Compute v2 bootstrap method. *thanks Jesse Scott*
*   Clarified the logic for finding the newly created DNS record for Rackspace Cloud DNS. *thanks Jesse Scott*
*   fix warning message to follow correct bucket naming guidelines. *thanks Michael Elfassy*
*   Bucket names cannot begin with the "goog" prefix. Also change for DNS compliant subdomain. *thanks Michael Elfassy*
*   VMWare vsphere provider refactor. *thanks Ohad Levy*
*   do not force trailing / on path. *thanks Ohad Levy*
*   Removes dead link to DNS tests. *thanks Paul Thornthwaite*
*   Adds link to Code Climate metrics. *thanks Paul Thornthwaite*
*   Extracts Changelog Rake task to class. *thanks Paul Thornthwaite*
*   Moves fog.io generation a prerequsite. *thanks Paul Thornthwaite*
*   Extracts docs rake tasks to a class. *thanks Paul Thornthwaite*
*   Extracts testing Rake tasks to class. *thanks Paul Thornthwaite*
*   Moves new Task classes to better location. *thanks Paul Thornthwaite*
*   Revert "[core] Adds fog User-Agent header". *thanks Paul Thornthwaite*
*   Inconsistent usage of cpus / vpcus in libvirt / requests.     Reported number of cpus was always 1 for libvirt domains. *thanks Romain Vrignaud*
*   use CGI.escape when encoding the POST body. *thanks Sam Cooper*
*   Added versioned delete_multiple_objects support. *thanks Timur Alperovich*
*   Add support for volume_pool_name. *thanks Vincent Demeester*
*   fixes issue#1313 ~ Creating user via `Aws.iam.users` ignores `:path`. *thanks VirtualStaticVoid*
*   revised create logic to default path to '/'. *thanks VirtualStaticVoid*
*   added test for create logic to default path to '/'. *thanks VirtualStaticVoid*
*   added support for mock. *thanks VirtualStaticVoid*
*   revised test order. *thanks VirtualStaticVoid*
*   README: s/'cloud computing'/'cloud services'. *thanks Wesley Beary*
*   Adding explicit support for metadata for Rackspace compute_v2. *thanks heyryanw*
*   removed Fog::AWS[:rds] this was creating issues with was security credentials. *thanks mauro catenacci*
*   Adding public_ip_address and private_ip_address to Fog::Compute::RackspaceV2::Server. *thanks sashap*
*   Adding bootstrap and setup for RackspaceV2 servers. *thanks sashap*

#### [openstack]
*   Add Accept header with application/json media type to requests. *thanks Andrew Donald Kennedy*
*   Refactor Openstack Authentication. *thanks Nelvin Driz*
*   Fix Typo in Merge of Authentication Refactoring. *thanks Nelvin Driz*
*   Make use of the unscoped token for reauthentication. *thanks Philip Mark M. Deazeta*

#### [openstack|compute]
*   Add "Reset Server State" request. *thanks Nelvin Driz*
*   Add `get_limits` request. *thanks Nelvin Driz*

#### [openstack|identity]
*   use tenant_id parameter in users model. *thanks Philip Mark M. Deazeta*
*   Add `attr_accessor :unscoped_token` to Mock. *thanks Philip Mark M. Deazeta*

#### [opnestack|identity]
*   Added set_tenant request for identity service. *thanks Philip Mark M. Deazeta*

#### [rackspace|computev2]
*   aded test for bootstrap. *thanks Brian Hartsock*

#### [rackspace|dns]
*   fixed tests, merged some formatting to reduce duplication. *thanks Brian Hartsock*

#### [rackspace|storage]
*   rackspace files tests should be pending in mocked mode. *thanks geemus*

#### [readme]
*   update outdated sponsorship section. *thanks geemus*

#### [vsphere]
*   ensure reload works correctly for server. *thanks Ohad Levy*


## 1.7.0 11/04/2012
*Hash* aa853488c9d84d849f52cf348787030fbb963163

Statistic     | Value
------------- | --------:
Collaborators | 41
Downloads     | 1216554
Forks         | 599
Open Issues   | 80
Watchers      | 2206

**MVP!** Nick Osborn

#### [AWS::Mock|create_image]
*   automatic registration of ebs image upon image_create. *thanks Chielo Zimmerman*

#### [AWS|Glacier]
*   Fix description header not being passed through Fog.escape. *thanks Frederick Cheung*

#### [Brightbox]
*   Change code to return Single user. *thanks Hemant Kumar*
*   Adds ApiClient Model. *thanks Hemant Kumar*
*   Add identifier to get_account method. *thanks Hemant Kumar*
*   Reuses connection for image selection. *thanks Paul Thornthwaite*
*   Fixes cloud IP options default. *thanks Paul Thornthwaite*
*   Deprecates overloaded requests. *thanks Paul Thornthwaite*
*   Standardises update_firewall_rule. *thanks Paul Thornthwaite*
*   Deprecates old account update request. *thanks Paul Thornthwaite*
*   Use correct request to update account. *thanks Paul Thornthwaite*
*   Brightbox tests should select the smallest official image. *thanks Steve Smith*
*   Allows authentication as user. *thanks Steve Smith*
*   Allow users to lists all accounts associated with the current credentials. *thanks Steve Smith*
*   add support for User Applications. *thanks Steve Smith*

#### [HP|Storage]
*   remove debug output. *thanks geemus*

#### [Ninefold|Storage]
*   Use Atmos in Ninefold storage. *thanks Timur Alperovich*

#### [aws|auto_scaling]
*   update display_*_types. *thanks Nick Osborn*
*   Fix documentation URL. *thanks Nick Osborn*
*   support termination policies. *thanks Nick Osborn*
*   correct DefaultCooldown in mocks. *thanks Nick Osborn*
*   documentation tinkering. *thanks Nick Osborn*
*   support ForceDelete for delete_auto_scaling_group. *thanks Nick Osborn*
*   better tag handling. *thanks Nick Osborn*
*   DRY out ARNs in mocks. *thanks Nick Osborn*
*   document Tags option to create_auto_scaling_group. *thanks Nick Osborn*
*   fix AutoScalingGroupName in mock. *thanks Nick Osborn*
*   expose delete_notification_configuration request. *thanks Nick Osborn*
*   improve describe_*_types test. *thanks Nick Osborn*
*   improve notification configurations. *thanks Nick Osborn*
*   s/data/self.data/ in mocks. *thanks Nick Osborn*
*   mark describe_*_types requests as idempotent. *thanks Nick Osborn*
*   tags support. *thanks Nick Osborn*
*   expose termination policies in group model. *thanks Nick Osborn*

#### [aws|autoscaling]
*   fix casting availability_zones to array in create_auto_scaling_group mock. *thanks geemus*
*   mark problematic auto_scaling mocked tests as pending     see also #1183. *thanks geemus*

#### [aws|cdn]
*   cover AWS CDN with some non-exhaustive tests. *thanks Brice Figureau*
*   Implements AWS CDN get_invalidation request. *thanks Brice Figureau*
*   fix incorrect get_invalidation result. *thanks Brice Figureau*
*   add aws cdn tests for streaming distributions. *thanks Brice Figureau*
*   fix cdn documentation. *thanks Brice Figureau*
*   AWS CDN models. *thanks Brice Figureau*
*   add request mock support for AWS Cloudfront. *thanks Brice Figureau*
*   fix up failing mocked tests around invalidations. *thanks geemus*

#### [aws|cloud_watch]
*   Add instrumentation support. *thanks Michael Hale*

#### [aws|ec2]
*   describe_availability_zones parser handles nested <item> tags. *thanks Aaron Suggs*

#### [aws|rds]
*   add region and owner_id as RDS connection attributes. *thanks Benton Roberts*
*   add request definitions for RDS tagging and increment RDS API version. *thanks Benton Roberts*
*   add tests for RDS tagging requests. *thanks Benton Roberts*
*   add tagging methods to RDS server model. *thanks Benton Roberts*
*   add tagging tests for RDS server model. *thanks Benton Roberts*
*   store mocked RDS instance tags in connection object. *thanks Benton Roberts*
*   FIX non-1.8-compliant syntax bug. *thanks Benton Roberts*

#### [misc]
*   modified create function to include options. changed "diskConfig" to "OS-DCF:diskConfig" to allow disk configuration to be properly set. *thanks Alex Dunn*
*   Removed options attribute and used the already existing disk_config attribute instead. Passed in options hash to create_server method with disk_config attribute unless nil. *thanks Alex Dunn*
*   Replace nil return value with private IP, implementation as in public_ip_address method. *thanks Andrew Taylor*
*   Change the metadata method to support amazon tags such as x-amz-website-redirect-location. *thanks Arthur Gunawan*
*   Fix issue #1245 - mock register_image fails with block device mapping. *thanks Brice Figureau*
*   Added ninefold load balancers. *thanks Carl Woodward*
*   Added other commands for load balancers. *thanks Carl Woodward*
*   Fix create load balancer test. *thanks Carl Woodward*
*   Add assign list to load balancer rules and update load balancer rule for     Ninefold. *thanks Carl Woodward*
*   Add remove from load balancer test. *thanks Carl Woodward*
*   Move ssh private_key, public_key, username to Server model to reduce duplication. *thanks Carlos Sanchez*
*   Joyent server creation should not wait for server to be ready. *thanks Carlos Sanchez*
*   Added ParameterValue to engine_defaults_parser. *thanks Curtis Stewart*
*   Added outputs 'Description' field to DescribeStacks parser. *thanks Curtis Stewart*
*   Make region available to mock. *thanks Edward Muller*
*   Added OpenStack::Server#created and #updated. *thanks Eric Hodel*
*   Use :default from tests/.fog for test credentials. *thanks Eric Hodel*
*   Only run mocked tests by default. *thanks Eric Hodel*
*   Tested handling of Openstack server created and updated times. *thanks Eric Hodel*
*   create image now supports block device mapping. *thanks Eric Stonfer*
*   create image extended to allow for EBS volume handling. *thanks Eric Stonfer*
*   fix indexed_param usage. *thanks Eric Stonfer*
*   forgot to commit some changes. *thanks Eric Stonfer*
*   when querying servers by icenter group, servers will return nil.  fixed this. *thanks Eugene Howe*
*   fixed bad request names. *thanks Eugene Howe*
*   correct the options checking in BlueBox create_block. *thanks Josh Kalderimis*
*   changed list nova servers request to get details. *thanks Julio Feijo*
*   Correct the handling of the power_on option. *thanks Karan Misra*
*   Added support for scheduler_hints in OpenStack. *thanks Mariusz Pietrzyk*
*   add force option to auto scaling group destroy method. *thanks Michael Hale*
*   use hash args. *thanks Michael Hale*
*   [AWS|cloud_watch]: fix list_metrics NextMarker should be NextToken. *thanks Michael Hale*
*   Fix to resolve "objectid is required for this operation" error message when calling public_url. *thanks Michael Harrison*
*   Fix to resolve "objectid is required for this operation" error message when calling public_url. *thanks Michael Harrison*
*   Return nil on public_url if the file isn't present on the cloud storage. *thanks Michael Harrison*
*   Added file existence check before file deletion attempt. *thanks Michael Harrison*
*   Rolled back deletion guard as some may be using the exception raised in their code. *thanks Michael Harrison*
*   Changed Atmos::FIle.public_url so an exception is thrown if the file doesn't exist on the cloud storage. *thanks Michael Harrison*
*   Changed Atmos::FIle.public_url so returns nil if the file doesn't exist on the cloud storage.  This brings the method in line with other storage implementations such as AWS and Rackspace. *thanks Michael Harrison*
*   Changed Atmos::FIle.public_url so checks for existence of the file on storage on every call to the method minimising the potential for a 404 error. *thanks Michael Harrison*
*   added documentation. *thanks Nick Huanuca*
*   ammend dest_folder disclaimer. *thanks Nick Huanuca*
*   fixed vm listing problem. *thanks Ohad Levy*
*   Allows tests to run against FOG_RC setting. *thanks Paul Thornthwaite*
*   Beginning implementation of RDS subnet groups. *thanks Rusty Geldmacher*
*   Changes RDS subnet attribute name from subnets to subnet_ids. *thanks Rusty Geldmacher*
*   allow port to be included in queue_url. *thanks Sairam*
*   Fixed typos in elasticache and rds describe_events.  Added better documentation of describe_events. *thanks Sean Hart*
*   Added test for describe_events.rb.  It is very simple, and I'm not familiar with Shindo, so may need some assistance expanding. *thanks Sean Hart*
*   Added parsing for Marker.  AWS limits response to 100 lines and gives you a marker to get the next batch with. *thanks Sean Hart*
*   Added missing header. *thanks Stephen von Takach*
*   Bumped mocked maximum value for provisioned iops. *thanks Thom Mahoney*
*   Ignore existing directory when creating on local storage. *thanks Thomas Wright*
*   Add config instructions to README. *thanks Thomas Wright*
*   Fix reference to config file. *thanks Thomas Wright*
*   expect public_key option instead of ssh_key on block create. *thanks Trevor Bramble*
*   Added usagePrice the hourly cost for a reserved instance. *thanks Ulf Mansson*
*   Added RDS describe_events. *thanks Your Name*
*   Created describe events for RDS. *thanks Your Name*
*   Update lib/fog/vsphere/requests/compute/vm_clone.rb. *thanks endzyme*
*   Update lib/fog/vsphere/requests/compute/vm_clone.rb. *thanks endzyme*
*   Update lib/fog/vsphere/requests/compute/vm_clone.rb. *thanks endzyme*

#### [ninefold|compute]
*   update load balancer tests to pass hash parameters for backwards compatability. *thanks geemus*
*   mark before/after blocks as pending in mocked mode also. *thanks geemus*

#### [openstack]
*   Authentication Mocks. *thanks Nelvin Driz*
*   Fix Failing Shindo Tests. *thanks Nelvin Driz*
*   Ensure String Username for Authentication. *thanks Nelvin Driz*
*   Changed volumes attributes of mocks from camelcase to     snakecase. *thanks Philip Mark M. Deazeta*
*   Updated mocks for quota, image, tenant and volumes. *thanks Philip Mark M. Deazeta*
*   Fixed mocks for failing shindo tests. *thanks Philip Mark M. Deazeta*
*   Updated 'image update' mocks. *thanks Philip Mark M. Deazeta*

#### [openstack|compute]
*   Added auth_token_expiration. *thanks Alfonso Juan Dillera*
*   Fixed security groups typos. *thanks Alfonso Juan Dillera*
*   Fix Server Mocks and `find_by_id` method. *thanks Nelvin Driz*

#### [openstack|identity]
*   Update for failing mock test. *thanks Alvin Garcia*
*   Update Identity Mocking Process. *thanks Nelvin Driz*
*   Update Fog Mocks on Authentication, User and Roles. *thanks Nelvin Driz*

#### [openstack|image]
*   Added update_members function. *thanks Alvin Garcia*
*   Added updateable attributes. *thanks Alvin Garcia*
*   Added optional attributes to set on create image. *thanks Alvin Garcia*
*   Fixed update image and list public images mocks. *thanks Alvin Garcia*
*   Fix Hash Access on Mock of Create Image. *thanks Nelvin Driz*

#### [openstack|network]
*   Add support for OpenStack Quantum. *thanks Ferran Rodenas*
*   Add filters to networks, ports and subnets. *thanks Ferran Rodenas*

#### [rackspace|identity]
*   user should be alphanumeric. *thanks geemus*


## 1.6.0 09/15/2012
*Hash* 4bd909557fd595a656ebd86a3d7c5849bd923fe1

Statistic     | Value
------------- | --------:
Collaborators | 40
Downloads     | 1015900
Forks         | 539
Open Issues   | 55
Watchers      | 2119

#### [AWS]
*   Implement signature v4. *thanks Frederick Cheung*
*   Create the time directly in tests, avoids using a method not present in 1.8.7. *thanks Frederick Cheung*
*   avoid spurious test failure when tag test returns before images test. *thanks Frederick Cheung*
*   Adding missing :glacier case for AWS.collections. *thanks Frederick Cheung*

#### [AWS|AutoScaling]
*   Typo in delete_autoscaling_group mock: Autoscaling->AutoScaling. *thanks Frederick Cheung*
*   fix group#instances. *thanks Frederick Cheung*
*   Fix describe_auto_scaling_groups parser added spurious nil groups. *thanks Frederick Cheung*
*   Fix delete_auto_scaling_group.rb mock not raising the same error as real code. *thanks Frederick Cheung*

#### [AWS|Compute]
*   Add the ablity to pass :version and use newer AWS API. *thanks Zuhaib M Siddique*

#### [AWS|Glacier]
*   Bare glacier service. *thanks Frederick Cheung*
*   single part uploads. *thanks Frederick Cheung*
*   multipart uploads. *thanks Frederick Cheung*
*   Jobs requests. *thanks Frederick Cheung*
*   vaults model. *thanks Frederick Cheung*
*   Use bytesize rather than length. *thanks Frederick Cheung*
*   models for archives. *thanks Frederick Cheung*
*   jobs model. *thanks Frederick Cheung*
*   Add notification configuration to model. *thanks Frederick Cheung*
*   mark tests as pending. *thanks Frederick Cheung*
*   byteslice is only available in 1.9.3 - add fallback for 1.9.2. *thanks Frederick Cheung*
*   fix 1.9.2 fallback. *thanks Frederick Cheung*
*   make 1.8.7 friendly. *thanks Frederick Cheung*
*   Fix job type constant. *thanks Frederick Cheung*
*   fix setting description on  multipart upload. *thanks Frederick Cheung*
*   fix name of header used for description. *thanks Frederick Cheung*
*   Allow filtering of jobs collection. *thanks Frederick Cheung*
*   Don't try to deserialize json when body is empty. *thanks Frederick Cheung*

#### [AWS|RDS]
*   expose the SnapshotType attribute & allow filtering by it. *thanks Frederick Cheung*

#### [AWS|Signaturev4]
*   allow symbols to be used as header/query keys. *thanks Frederick Cheung*

#### [AWS|Storage]
*   mark upload_part as idempotent so it will be retried automatically. *thanks Frederick Cheung*

#### [Brightbox]
*   Fix output format for brightbox cloud ip. *thanks Hemant Kumar*

#### [Brightbox|CloudIp]
*   Remove duplicate constant definition for port translators. *thanks Hemant Kumar*

#### [Cloudstack]
*   1.8.7 compat: on 1.8.7 '123'[0] returns the byte value of '0' and not '1'. *thanks Frederick Cheung*

#### [Core]
*   fix format_helper assuming p returns nil. *thanks Frederick Cheung*

#### [HP]
*   delete_if returns the array, not what was deleted. *thanks Frederick Cheung*

#### [OpenStack]
*   fixes wrong method name. *thanks Ohad Levy*

#### [Openstack]
*   Fix mock returning a hash instead of an array. *thanks Frederick Cheung*

#### [Openstack|Compute]
*   Security Groups are not assigned correctly to servers. *thanks Ohad Levy*

#### [aws|auto_scaling]
*   Add instrumentation support. *thanks Michael Hale*

#### [aws|compute]
*   fix typo in deprecation warning. *thanks Aaron Suggs*
*   Nicer interface for security group authorizations. *thanks Aaron Suggs*
*   Add instrumentation support. *thanks Dan Peterson*
*   Support creating and describing volumes with provisioned IOPS. *thanks Dan Peterson*
*   Get instance requests tests working. *thanks Dan Peterson*
*   Support for EBS-optimized instances. *thanks Dan Peterson*
*   Pass empty groupIds when mocking. *thanks Dan Peterson*
*   DescribeInstanceStatus code within eventsSet goes on the item. *thanks Dan Peterson*
*   fixes for spot request waiting     see also #841. *thanks geemus*
*   remove brittle instance tests which rely on tests running fast     p.s. these fail on travis-ci. *thanks geemus*
*   fix mock filters for internet gateways/subnets/vpcs. *thanks geemus*

#### [aws|elb]
*   Add instrumentation support. *thanks Dan Peterson*
*   fixes for mock tests. *thanks geemus*

#### [aws|iam]
*   Add instrumentation support. *thanks Dan Peterson*

#### [aws|rds]
*   Correct server#read_replica_identifiers when mocking. *thanks Aaron Suggs*
*   Mocking better supports reboot state. *thanks Aaron Suggs*
*   Mocking better supports modifying state. *thanks Aaron Suggs*
*   Fix server tests. *thanks Aaron Suggs*
*   Mocking support for read replicas. *thanks Aaron Suggs*
*   Mock support for setting AZ and MultiAZ. *thanks Aaron Suggs*

#### [brightbox]
*   Use first available image for server tests. *thanks Steve Smith*

#### [brightbox|ServerGroup]
*   ServerGroups can have a nil name. *thanks Steve Smith*

#### [brightbox|compute]
*   Merged outstanding work from Brightbox's fork. *thanks Paul Thornthwaite*
*   Implemented reboot using available API commands. *thanks Paul Thornthwaite*
*   Updates to Test helper for select image. *thanks Paul Thornthwaite*
*   Helper to get default image from API. *thanks Paul Thornthwaite*

#### [cloudstack|compute]
*   remove erroneous comma in merge command. *thanks geemus*

#### [compute|Ecloud]
*   Ecloud should not show up as a valid provider when not providing credentials. *thanks Eugene Howe*

#### [dynect|dns]
*   Only JSON decode when Content-Type says so. Fixes job handling. *thanks Dan Peterson*
*   Job polling should use original expected statuses. *thanks Dan Peterson*

#### [google/storage]
*   Fix docs for new GCS urls. *thanks Nat Welch*

#### [google|storage]
*   update expected format to remove StorageClass. *thanks geemus*
*   also update mocks to omit storageclass. *thanks geemus*

#### [hp|storage]
*   Use response_block param, as excon has deprecated implicit blocks. *thanks Ferran Rodenas*

#### [misc]
*   When using mock mode, Range header is now not ignored in get_object(). *thanks Ahmed Al Hafoudh*
*   Documentation error for delete_object. *thanks Alex Tambellini*
*   Add barebones configuration for Travis CI. *thanks Alexander Wenzowski*
*   add Travis CI build status image. *thanks Alexander Wenzowski*
*   notify #ruby-fog on freenode instead of emailing. *thanks Alexander Wenzowski*
*   remove repository_url from notification template     Interpolation of %{repository_url} is currently broken on Travis CI. *thanks Alexander Wenzowski*
*   CloudStack: added registerTemplate request. *thanks Aliaksei Kliuchnikau*
*   CloudStack: listTemplates, registerTemplate requests return hypervisor in the response. *thanks Aliaksei Kliuchnikau*
*   Enable AWS spot requests in a VPC by specifying subnet_id. *thanks Ben Turley*
*   Fix for RDS VPC subnet groups. *thanks Ben Turley*
*   parse ASCII code * in wildcard domain. Fixes #1093. *thanks Blake Gentry*
*   automatically figure out the elb hosted_zone_id if possible. *thanks Blake Gentry*
*   Add source for getting instance mac address. *thanks Carl Caum*
*   Only add VNC password and listen port if present. *thanks Carl Caum*
*   Revert 530122d. *thanks Carl Caum*
*   Abillity to List Images and List SSH Keys. *thanks Chirag Jog*
*   Add support to create, delete internet services. *thanks Chirag Jog*
*   Accept vCPUS and Memory as parameters while creating servers. *thanks Chirag Jog*
*   Minor Fixes: Remove unncessary prints. Use override_path instead of replace class variable path. *thanks Chirag Jog*
*   Fix support to add internet service to the existing Public Ip. *thanks Chirag Jog*
*   Support to configure vapp and add multiple internet services. *thanks Chirag Jog*
*   Remove uneccessary puts. *thanks Chirag Jog*
*   Add support to build/re-build/clobber gem/package/docs. *thanks Chirag Jog*
*   Fix minor issue. *thanks Chirag Jog*
*   Re-work based on Geemus's review.     Manage InternetService and NodeService as separate entities     Reload server status properly. *thanks Chirag Jog*
*   Revert Rakefile changes. *thanks Chirag Jog*
*   1.Ability to fetch/list Orgs, Vdcs, Vapps, Servers.     2.Support to customize CPUs and Password. *thanks Chirag Jog*
*   Add ability to configure a vApp with an Org-wide network and associated     firewall, NAT rules(limited support). *thanks Chirag Jog*
*   1.Fix Catalog Listing for vCD 1.5     2.Construct Valid XML to memory configuration     3.Fix Undeploy vCD 1.5. *thanks Chirag Jog*
*   Added m1.medium instance type for AWS flavors. *thanks Curtis Stewart*
*   - Updated "`@host"` variable to "noc.newservers.com" which is the current host for API calls     - Added two calls: add_server_by_configuration.rb and list_configurations.rb     -- These calls should be used instead of add_server and list_plans, although we still support them.     - General comments were updated. *thanks Diego Desani*
*   Add gsub to replace URL-encoded characters in the public_url method. *thanks Eric Chernuka*
*   fix reboot guest in vsphere to reboot rather than shutdown guest. *thanks Eric Stonfer*
*   added file upload and ip add capabilities. *thanks Eugene Howe*
*   added error handling for edge cases where there are no networks or ips. *thanks Eugene Howe*
*   [AWS|Glacier} basic vault operations. *thanks Frederick Cheung*
*   fix mock not returning the right data. *thanks Frederick Cheung*
*   set Content-MD5. *thanks Frederick Cheung*
*   Add fqdn to server attributes. *thanks Hemant Kumar*
*   Brightbox : Include licence_name in Image. *thanks Hemant Kumar*
*   Brightbox: Change licence_name type to Fog::Nullable::String. *thanks Hemant Kumar*
*   Add support for port translators. *thanks Hemant Kumar*
*   Rackspace Storage: new request, get_object_https_url. *thanks James Healy*
*   Rackspace Storage: new request, post_set_meta_temp_url_key. *thanks James Healy*
*   Rackspace Storage: a backslash shouldn't be escaped when signing URLS. *thanks James Healy*
*   add a basic spec for Rackspace::Storage#get_object_https_url. *thanks James Healy*
*   add basic spec for Rackspace::Storage##post_set_meta_temp_url_key. *thanks James Healy*
*   Rackspace Storage: fix expiring URLs that contain a hyphen. *thanks James Healy*
*   Add Serverlove directory. *thanks James Rose*
*   Basic Serverlove implementation. *thanks James Rose*
*   Wrong directory. *thanks James Rose*
*   Typo. *thanks James Rose*
*   Proper request arguments. *thanks James Rose*
*   Typo. *thanks James Rose*
*   Still wrong. *thanks James Rose*
*   Works. *thanks James Rose*
*   We want JSON. *thanks James Rose*
*   Typo. *thanks James Rose*
*   add high io flavor to aws flavors. *thanks Josh Lane*
*   Move Dynect endpoint from api2 to api-v4. *thanks Marc Seeger*
*   don't let the Paulistas be left out of the party. *thanks Martin Englund*
*   use 10.04 instead of 12.04. *thanks Martin Englund*
*   Google changed their URL scheme for Cloud Storage. *thanks Nat Welch*
*   Also change GCS url in dir and file models. *thanks Nat Welch*
*   Update lib/fog/hp/models/compute/image.rb. *thanks Neill Turner*
*   Update lib/fog/hp/models/compute/server.rb. *thanks Neill Turner*
*   Update lib/fog/aws/requests/compute/describe_instance_status.rb. *thanks Oleg*
*   Added new Server#fqdn attribute to test helper. *thanks Paul Thornthwaite*
*   Rewrite tests to use 1.8 compatible Hash syntax. *thanks Paul Thornthwaite*
*   Add missing providers to the all_providers list for testing. *thanks Paul Thornthwaite*
*   Use string not symbols for Storage tests to work with Shindo tagging. *thanks Paul Thornthwaite*
*   Retagged tests with strings to be skipped by Shindo. *thanks Paul Thornthwaite*
*   Tagged AWS URL test so correctly ignored by Shindo. *thanks Paul Thornthwaite*
*   Reduce maintenance of tests by using a dynamic list of providers. *thanks Paul Thornthwaite*
*   add support for multiple regions in Opentack. *thanks Pedro Perez*
*   Fixed the link to GitHub issues. *thanks Postmodern*
*   Change iprange --> ec2_secg in Mock. *thanks Rob Lockstone*
*   Added support for RDS VPC subnet groups. Bumped RDS API version to 2012-01-15. *thanks Rusty Geldmacher*
*   Added DBSubnetGroupName to test format for RDS instances. *thanks Rusty Geldmacher*
*   Adding server love disk model. *thanks Sean Handley*
*   Changed disk model based on responses from real API requests. *thanks Sean Handley*
*   Set up drive objects (not disks). *thanks Sean Handley*
*   If you use info, you get all the info. *thanks Sean Handley*
*   Alias the encryption cipher. *thanks Sean Handley*
*   Sometimes the response body is empty. *thanks Sean Handley*
*   Destroying drives is easy. *thanks Sean Handley*
*   Allowed setting of params as k/v pairs. *thanks Sean Handley*
*   Added create/update functionality. *thanks Sean Handley*
*   Made create/save conform to the Fog API. *thanks Sean Handley*
*   Returning self is totes better than bools. *thanks Sean Handley*
*   Fog calls drives "images", rename for consistency. *thanks Sean Handley*
*   Beginnings of shin do request tests. *thanks Sean Handley*
*   Need these to run the server love tests. *thanks Sean Handley*
*   Beginnings of tests for image operations. *thanks Sean Handley*
*   Adding mock for easier testing. *thanks Sean Handley*
*   Added get_image function. *thanks Sean Handley*
*   Added meaningful test for updating images. *thanks Sean Handley*
*   Typo!. *thanks Sean Handley*
*   Fix conflict. *thanks Sean Handley*
*   This shouldn't be here. *thanks Sean Handley*
*   Can't run shindo tests with old references. *thanks Sean Handley*
*   Added loading of standard image. *thanks Sean Handley*
*   Shindo tests pass. *thanks Sean Handley*
*   Test that we can view servers. *thanks Sean Handley*
*   Whitespace adjustments. *thanks Sean Handley*
*   CRUDs + tests for servers. *thanks Sean Handley*
*   Added server power cycle actions + basic tests. *thanks Sean Handley*
*   Add new request methods to server object. *thanks Sean Handley*
*   Use get_server, not get_image. *thanks Sean Handley*
*   Need a mock server id. *thanks Sean Handley*
*   This was plain wrong - works now!. *thanks Sean Handley*
*   Don't start servers by default. *thanks Sean Handley*
*   Contrary to the documentation, this actually     returns a 200 status rather than a 204. *thanks Sean Handley*
*   Allow setting of memory and disk drives. *thanks Sean Handley*
*   Allow DHCP assignment by default. *thanks Sean Handley*
*   Key 'vnc:ip' was invalid. *thanks Sean Handley*
*   Update allowed attributes and defaults. *thanks Sean Handley*
*   Increase test drive size to accommodate a real     image. *thanks Sean Handley*
*   Without setting SMP the web UI won't load :-/. *thanks Sean Handley*
*   Reduce from 80GB to 20GB - big enough, save space. *thanks Sean Handley*
*   Standard images need to be unzipped. *thanks Sean Handley*
*   Need to wait for imaging to complete. *thanks Sean Handley*
*   Add a pseudorandom password generator for VNC. *thanks Sean Handley*
*   Auto generate VNC password randomly. *thanks Sean Handley*
*   Used the amazon published endpoints for sqs as defined at http://docs.amazonwebservices.com/general/latest/gr/rande.html#sqs_region. *thanks Stuart Eccles*
*   Better mocks for invalid Provisioned IOPS values. *thanks Thom Mahoney*
*   Add generic support for EMC Atmos. *thanks Timur Alperovich*
*   Submit password/ssh_key/username through POST body. *thanks Trevor Bramble*
*   Update public_url to handle new header casings from Rackspace. *thanks Zachary Danger Campbell*
*   CloudStack: images.get always returns nil - fixed. *thanks alex*
*   add changelog for 1.5.0. *thanks geemus*
*   fixes for cloudstack mock tests     see #1090. *thanks geemus*
*   fix mocked elb tests by including InstanceProtocol     closes #1090. *thanks geemus*
*   expand travis config, build more rubies, use non-threaded runner. *thanks geemus*
*   just run mri for now on travis. *thanks geemus*
*   remove empty failure block from model_helper. *thanks geemus*
*   allow 1.8.7 to fail and not report for now (until I can work out why it fails when 1.9.x works. *thanks geemus*
*   return to expecting 1.8.7 to pass. *thanks geemus*
*   fix deprecated requires in Rakefile. *thanks geemus*
*   Made steps to get update/create working. Work in progress. *thanks seanhandley*
*   Update lib/fog/aws/models/compute/security_group.rb. *thanks vkhatri*

#### [rackspace|blockstorage]
*   Add volume tests. *thanks Brad Gignac*
*   Add volume type tests. *thanks Brad Gignac*
*   Add snapshot tests. *thanks Brad Gignac*
*   Add relationship between volumes and snapshots. *thanks Brad Gignac*
*   Add block storage provider. *thanks Julio Feijo*
*   Add volume types to block storage. *thanks Julio Feijo*
*   Add snapshots to block storage. *thanks Julio Feijo*

#### [rackspace|compute]
*   Add service for Cloud Servers v2.0. *thanks Brad Gignac*
*   Add flavors and images. *thanks Brad Gignac*
*   Add servers model and collection. *thanks Brad Gignac*
*   Set password attribute on V2 servers. *thanks Brad Gignac*
*   Don't intern nil strings. *thanks Brad Gignac*
*   Add method for listing attachments. *thanks Brad Gignac*
*   Add tests for volume attachments. *thanks Brad Gignac*
*   Improve attachment test reliability. *thanks Brad Gignac*
*   Add attachments model and collection. *thanks Julio Feijo*

#### [rackspace|storage]
*   Override path when generating sha1 to make tests past. *thanks Brian Hartsock*

#### [serverlove|compute]
*   fix serverlove tests for 1.8.7 compatibility. *thanks Frederick Cheung*
*   fix serverlove tests for 1.8.7 compatibility. *thanks geemus*


## 1.5.0 07/28/2012
*Hash* 2e57e2029abbb618411c20f8974e64d8d3fd31fe

Statistic     | Value
------------- | --------:
Collaborators | 36
Downloads     | 870008
Forks         | 500
Open Issues   | 44
Watchers      | 2074

#### [AWS|Autoscaling]
*   fix group#instances returning all autoscaled instances in the account. *thanks Frederick Cheung*

#### [Libvirt]
*   fixed incorrect mock method signature. *thanks Ohad Levy*
*   ensure Fog volumes do not raise on LVM based volumes. *thanks Ohad Levy*

#### [aws|compute]
*   Address#destroy handles VPC addresses, improve address allocate/release mocking for VPC. *thanks Dan Peterson*

#### [aws|elasticache]
*   Fix bug in cache cluster test. *thanks Benton Roberts*
*   Remove erroneous whitespace trimming. *thanks Benton Roberts*
*   Add Elasticache service-level mocking support. *thanks Benton Roberts*
*   Add mocking for cache cluster requests. *thanks Benton Roberts*
*   Change modify_cache_cluster test to work in mocking mode. *thanks Benton Roberts*
*   Enable mocking for elasticache cluster tests. *thanks Benton Roberts*
*   Mock raises NotFound Exception when AWS does. *thanks Benton Roberts*

#### [aws|storage]
*   Default to false for persistent connections. *thanks Kenny Johnston*

#### [cloudstack|security_group]
*   fix rule revoke mock. *thanks Josh Lane*

#### [cloudstack|security_groups]
*   add groups and rules. *thanks Josh Lane & Jason Hansen*

#### [cloudstack|server]
*   assign security group. *thanks Josh Lane & Jason Hansen*

#### [dynect|dns]
*   No more recursion when polling jobs. Raise an error if the body indicates failure. *thanks Dan Peterson*

#### [fix-ephemeral-naming]
*   Typo in ephemeral naming. *thanks Josh Pasqualetto*

#### [joyent|compute]
*   fix dataset format in tests. *thanks geemus*

#### [local|storage]
*   mark tests pending in mock mode. *thanks geemus*

#### [misc]
*   fix changelog task for github API v3. *thanks Aaron Suggs*
*   update changelog for release 1.4.0. *thanks Aaron Suggs*
*   changelog: backdate to release data. *thanks Aaron Suggs*
*   Local storage support for #public_url. *thanks Adam Tanner*
*   Bugfix in Fog::DNS::AWS::Records.all!. *thanks Alexander Kolesen*
*   Fix for stopping all the servers instead of just specified servers. *thanks Avrohom Katz*
*   private ip address should start with a 10. *thanks Avrohom Katz*
*   Use proper signature when testing with aws mock. *thanks Bohuslav Kabrda*
*   The user must be destroyed even in mock mode, otherwise completely unrelated tests fail (e.g. tests/aws/models/iam/users_tests.rb). *thanks Bohuslav Kabrda*
*   The condition here should be the same as for destroying, so that we test iff the instance gets destroyed. *thanks Bohuslav Kabrda*
*   The assignment correctly returns nil, just the test has to react to it. *thanks Bohuslav Kabrda*
*   The assignment correctly returns false, just the test has to react to it. *thanks Bohuslav Kabrda*
*   Include this to make refresh_credentials_if_expired method work properly with Mock. *thanks Bohuslav Kabrda*
*   Fix the number where credentials expire - if too high, other tests will fail. *thanks Bohuslav Kabrda*
*   Fix openstack tests. *thanks Bohuslav Kabrda*
*   Fix more openstack mock tests failures. *thanks Bohuslav Kabrda*
*   Add the mock urls to fix some more openstack tests. *thanks Bohuslav Kabrda*
*   Fix minor typos and incorrect types in openstack volume tests. *thanks Bohuslav Kabrda*
*   More typos in openstack server tests. *thanks Bohuslav Kabrda*
*   Rework the quota mock testing to work and be more comfortable. *thanks Bohuslav Kabrda*
*   Must use values, so that connection.list_roles gets corrent argument. *thanks Bohuslav Kabrda*
*   Deleting returns nothing, so do not expect role. *thanks Bohuslav Kabrda*
*   Properly check whether role is present. *thanks Bohuslav Kabrda*
*   Return the properly updated image. *thanks Bohuslav Kabrda*
*   Add the 'new_image' public images, so that find_by_id can find it. *thanks Bohuslav Kabrda*
*   The pending block fails the outer one => make sure we return proper result. *thanks Bohuslav Kabrda*
*   Use proper parameters when testing deploying cloudstact VMs. *thanks Bohuslav Kabrda*
*   This was implemented right previously, shouldn't have changed it. *thanks Bohuslav Kabrda*
*   Correct solution for subnet failing tests - use a collection in self.data. *thanks Bohuslav Kabrda*
*   Do the same thing for vpcs as previously done for subnets. *thanks Bohuslav Kabrda*
*   ...and the same for dhcp_options. *thanks Bohuslav Kabrda*
*   And the same for internet gateways. *thanks Bohuslav Kabrda*
*   Fixes the failure for hp storage. *thanks Bohuslav Kabrda*
*   [rackspace|databases| Add service tests. *thanks Brad Gignac*
*   fix for RDS mocking to avoid state flipping between "modifying" and "available". *thanks Brian Nelson*
*   Fix typo listing datacenters. *thanks Carlos Sanchez*
*   Stop vSphere vms before destroying, or destroy will fail. *thanks Carlos Sanchez*
*   Add a failure for #1014. :v:. *thanks Dylan Egan*
*   Only dup `@attributes` if it's not nil. *thanks Edward Muller*
*   each based pagination for Fog::AWS::IAM#users. *thanks Edward Muller*
*   fixes elb test in mocking mode. *thanks Eric Stonfer*
*   fix running subnet tests in mocking mode. *thanks Eric Stonfer*
*   fix subnet tests in mocking mode. *thanks Eric Stonfer*
*   fog bombs out on ruby 1.8.x because it cannot find Mutex. *thanks Eric Stonfer*
*   fix not pulling InstanceProtocol from the xml. *thanks Frederick Cheung*
*   Add Sao Paulo server to Amazon RDS known regions. *thanks Irio Irineu Musskopf Junior*
*   Add Sao Paulo server to Amazon SQS known regions. *thanks Irio Irineu Musskopf Junior*
*   Fix bug in local storage #copy_object. *thanks Jade Tucker*
*   Add and get SSL certificates to Rackspace Soft LB. *thanks Justin Barry*
*   Default to being less pessimistic about excon. *thanks Kevin Moore*
*   Fix ssh key behavior when passing specified private keys to ssh/scp. *thanks Marc Seeger*
*   Should not modify passed in "params" variable since block might run several times due to authentication failure producing erroneous path. *thanks Max Stepanov*
*   As discussed in #991, this converts the readme from SimpleMarkup to Markdown. *thanks Mike Fiedler*
*   added PeopleAdmin to list of users. *thanks Mike Manewitz*
*   Fixing typo bug in rackspace load balancer set_ssl_termination request. *thanks Paul*
*   add us-east-1e to mock. *thanks Shai Rosenfeld*
*   Pass up all the options that have been assigned. *thanks Trotter Cashion*
*   Pass options on to AutoScalingGroup. *thanks Trotter Cashion*
*   Add better ScalingPolicy support. *thanks Trotter Cashion*
*   Add more AWS Alarm functionality. *thanks Trotter Cashion*
*   Add delete mocks. *thanks Trotter Cashion*
*   Properly array-ify keys for create_auto_scaling_group. *thanks Trotter Cashion*
*   Add tags to autoscaling groups. *thanks Trotter Cashion*
*   Enable tests when mocking. *thanks Trotter Cashion*
*   Recognize ninefold_api_url option for pre-production testing. *thanks Warren Bain*
*   remove specs (likely from a bad merge). *thanks geemus*
*   update tests/helper to have bare_metal_cloud instead of new_servers. *thanks geemus*
*   Mock for filter ec2 instances by group name. *thanks phillc*

#### [openstack]
*   Fix Authentication for OpenStack v1.1 Authentication. *thanks Nelvin Driz*

#### [openstack|compute]
*   Add filters to list servers details. *thanks Ferran Rodenas*
*   Added adminPass attribute in create_server. *thanks Philip Mark M. Deazeta*
*   fix method signature for mock list_servers_detail. *thanks geemus*

#### [openstack|image]
*   Stream OpenStack image. *thanks Vadim Spivak*

#### [rackspace|databases]
*   Add read-only support for Rackspace Cloud Databases. *thanks Brad Gignac*
*   Add write support for Rackspace Cloud Databases. *thanks Brad Gignac*
*   Register Rackspace Cloud Databases service with Fog. *thanks Brad Gignac*
*   Remove "list/details" API calls in favor of "list" calls. *thanks Brad Gignac*
*   Add model tests. *thanks Brad Gignac*
*   Finish request tests. *thanks Brad Gignac*
*   Remove old comments. *thanks Brad Gignac*
*   Handle breaking API changes. *thanks Brad Gignac*
*   Initial pass at request tests. *thanks Brian Hartsock*

#### [rackspace|identity]
*   Add Rackspace identity service. *thanks Brad Gignac*
*   Add requests and request tests. *thanks Brad Gignac*
*   Add user model and collection with tests. *thanks Brad Gignac*
*   Handle non-array responses from list calls. *thanks Brad Gignac*
*   Better checking around hash/array responses. *thanks Brad Gignac*
*   Handle NotAuthorized respones from the identity API in the user model. *thanks Brian Hartsock*
*   use a valid username in tests. *thanks geemus*

#### [rackspace|lb]
*   fixed broken tests because of API format changes. *thanks Brian Hartsock*
*   ssl termination fixes. *thanks Brian Hartsock*
*   moved to Fog::JSON.encode instead of MultiJson.encode. *thanks Brian Hartsock*


## 1.4.0 06/24/2012
*Hash* 24e0be755e251159f07d5d82beb1e8ef57c962d9

Statistic     | Value
------------- | --------:
Collaborators | 35
Downloads     | 800348
Forks         | 477
Open Issues   | 43
Watchers      | 2080

**MVP!** Nelvin Driz

#### [AWS]
*   make beanstalk, cdn, cloudformation, cloudwatch, elasticache, elb, storage, rds, ses, sns, route53 temporary credential friendly. *thanks Frederick Cheung*

#### [AWS|Auto Scale]
*   Add support for put_notification_configuration and     change AWS API to use 01-01-2011 Spec. *thanks Zuhaib M Siddique*

#### [AWS|Autoscale]
*   Fixing Parameters notes for autoscale create launch     configuration for InstanceMonitoring.  Credit goes to boto,     https://github.com/boto/boto/blob/develop/boto/ec2/autoscale/__init__.py     , for having it correct. *thanks Zuhaib M Siddique*
*   Fixing Parameters notes for autoscale create launch     configuration for InstanceMonitoring.  Credit goes to boto,     https://github.com/boto/boto/blob/develop/boto/ec2/autoscale/__init__.py     , for having it correct. *thanks Zuhaib M Siddique*

#### [Openstack|Compute]
*   Usage Requests. *thanks Hunter Nield*
*   Migration and Console output. *thanks Hunter Nield*
*   server methods for console and migration. *thanks Hunter Nield*
*   Minor address cleanup. *thanks Hunter Nield*

#### [aws|address]
*   fixes release_address for VPC EIPs      * amazon requires allocation_id only for vpc eips, and public_ip otherwise. *thanks Albert Choi*

#### [aws|beanstalk]
*   Added missing :beanstalk case. *thanks George Scott*
*   Added #load_balancer method. *thanks George Scott*
*   Serialize keys for SourceConfiguration. *thanks George Scott*
*   Added modify method for template. *thanks George Scott*
*   Support different AWS regions. *thanks George Scott*
*   Added swap_cnames method. *thanks George Scott*

#### [aws|compute]
*   add networkInterfaceSet context to EC2 instance parser. *thanks Benton Roberts*

#### [aws|dns]
*   Allow both Ruby and AWS style names for alias. *thanks George Scott*
*   Support for latency/weighted resource sets. *thanks George Scott*
*   Fixed #all iteration. *thanks George Scott*
*   Reimplemented #get. *thanks George Scott*
*   Added #all! method to Records. *thanks George Scott*

#### [aws|dynamodb]
*   correct batch_put_item to batch_write_item for consistency with API. *thanks geemus*

#### [aws|elb]
*   Failing test for load_balancers marker support. *thanks Dan Peterson*
*   Deprecate describe_load_balancers with just an array of names. *thanks Dan Peterson*
*   Marker support for describe_load_balancers. *thanks Dan Peterson*
*   Fix use of describe_load_balancers in tests. *thanks Dan Peterson*
*   load_balancers.get(nil) returns nil instead of the first of all load balancers. *thanks Dan Peterson*

#### [aws|iam]
*   Add test for AWS[:iam].get_user. *thanks Benton Roberts*
*   add test for AWS[:iam].get_user_policy. *thanks Benton Roberts*
*   FIX - make arguments AWS::IAM.get_user conform to expected standard for this module. *thanks Benton Roberts*
*   Fix Users model to comply with updated request parameter set. *thanks Benton Roberts*
*   mark role tests as pending in mock mode. *thanks geemus*

#### [aws|storage]
*   fix flipped logic on valid acl check     closes #889. *thanks geemus*
*   fix method signature for setup_credentials. *thanks geemus*

#### [aws|storage|]
*   Make get_object_http_url use correct S3 host in returned URL. *thanks Michiel Sikkes*
*   Make get_object_http_url use correct S3 host in returned URL. *thanks Michiel Sikkes*

#### [brightbox|compute]
*   Updated image reference where unfortunately hardcoded. *thanks Paul Thornthwaite*
*   Remove resize request since not available. *thanks Paul Thornthwaite*
*   Update format tests for new attributes on Cloud IPs. *thanks Paul Thornthwaite*
*   Update format tests for "fqdn" attribute. *thanks Paul Thornthwaite*
*   Update format tests for updates to Image. *thanks Paul Thornthwaite*

#### [cloudstack]
*   prevent mock test failure when cloudstack credentials are not defined. *thanks geemus*
*   add to list of providers so it can be skipped when lacking credentials. *thanks geemus*

#### [cloudstack|compute]
*   zones,flavors,images,address. *thanks Jason Hansen & Josh Lane*
*   support async jobs. *thanks Jason Hansen & Josh Lane*
*   server abstraction and mocks. *thanks Josh Lane & Jason Hansen*
*   volumes support. *thanks Josh Lane & Jason Hansen*

#### [compute]
*   volume tests. *thanks Josh Lane & Jason Hansen*

#### [compute|aws]
*   Apply tags to volume at creation. *thanks Dan Carley*
*   Respect extra register_image options when mocking. *thanks Dan Peterson*
*   extend polling interval for spot_requests bootstrap. *thanks geemus*
*   cleanup internet_gateway mocks and remove debug output. *thanks geemus*

#### [compute|openstack]
*   update server attributes for shared compute tests. *thanks geemus*
*   cleanup for list security groups request/mock. *thanks geemus*

#### [docs]
*   fix link to EngineYard logo (broken in /storage, /compute, etc.). *thanks Len*

#### [ecloud|compute]
*   Adding multiple disks at once was not working properly. *thanks Eugene Howe*
*   fix optional params for validate_data     closes #969. *thanks geemus*

#### [glesys|compute]
*   update server/status format to include cpu hash and warnings. *thanks Anton Lindström*
*   add reboot and compute test params. *thanks Anton Lindström*

#### [hp|compute]
*   fix tests to properly set default base image. *thanks geemus*

#### [ibm|compute]
*   Typo in parameter name, should be storageID. *thanks Decklin Foster*

#### [joyent|compute]
*   Fixes issue where params are not properly passed to #keys_create     from #create_key. *thanks Kevin Chan*
*   Added #list_datacenters. *thanks Kevin Chan*
*   Support for DSA keys for auth. *thanks Kevin Chan*

#### [libVirt]
*   added tests. *thanks Amos Benari*

#### [libvirt]
*   refactored libvirt entire code. *thanks Ohad Levy*
*   expose node hostname. *thanks Ohad Levy*
*   added display attributes and allowed to change display of a running server. *thanks Ohad Levy*
*   volumes dev names must be uniq. *thanks Ohad Levy*
*   makes libvirt code more debian friendly. *thanks Ohad Levy*
*   - ensure no nil pools are returned. *thanks Ohad Levy*
*   Fix SSH keyfile being pulled from wrong param. *thanks brookemckim*
*   skip tests if ruby-libvirt is unavailable. *thanks geemus*
*   correct error message when skipping tests. *thanks geemus*

#### [misc]
*   Add support for internal ELBs in VPC. *thanks Aaron Bell*
*   cleaning up model. *thanks Aaron Bell*
*   fix parser to show scheme, add test for internal ELB creation. *thanks Aaron Bell*
*   fixing test. *thanks Aaron Bell*
*   add scheme to elb helper. *thanks Aaron Bell*
*   adds batch_put_item functionality to AWS dynamodb + test. *thanks Alex Gaudio*
*   Fixed non-persistent connections handling to AWS. *thanks Alexander Kolesen*
*   Fixed handling options[:persistent] in some cases. *thanks Alexander Kolesen*
*   added mock implementation. *thanks Amos Benari*
*   removed unneeded dependency,. *thanks Amos Benari*
*   new rbovirt version. *thanks Amos Benari*
*   use constant for GB. *thanks Amos Benari*
*   Adding network interface information and security group ids. *thanks Artem Veremey*
*   Adding network interface information and security group ids to the model. *thanks Artem Veremey*
*   Store the region for S3. *thanks Ben Butler-Cole*
*   add create_hosted_zone and get_hosted_zone request mocks. *thanks Bulat Shakirzyanov*
*   add list_hosted_zones request mock. *thanks Bulat Shakirzyanov*
*   add change_resource_record_set request mock. *thanks Bulat Shakirzyanov*
*   fix response codes and formatting. *thanks Bulat Shakirzyanov*
*   fix typos. *thanks Bulat Shakirzyanov*
*   fix identifiers. *thanks Bulat Shakirzyanov*
*   use hard-coded sample value to eliminate randomness. *thanks Bulat Shakirzyanov*
*   fix typos. *thanks Bulat Shakirzyanov*
*   fix zone id in create_hosted_zone response. *thanks Bulat Shakirzyanov*
*   fix attribute name. *thanks Bulat Shakirzyanov*
*   add authorize and revoke port range for security group. *thanks Bulat Shakirzyanov*
*   Fix typo. *thanks Christopher Meiklejohn*
*   Specify image_ref rather than trying to instantiate object. *thanks Christopher Meiklejohn*
*   Fog::Compute::AWS::Address#server -> assigned Server. *thanks Dr Nic Williams*
*   fix auto-discovery for HP Cloud by fog bin. *thanks Dr Nic Williams*
*   whitespace. :bomb: :v:. *thanks Dylan Egan*
*   Default to false for persistent connections. You can't pass in false. This now behaves like other connections in fog. :v:. *thanks Dylan Egan*
*   Idempotent Dynect calls. :v:. *thanks Dylan Egan*
*   Fix up describe_volume_status to work with THE ARRAYZ. :v:. *thanks Dylan Egan*
*   Fog::AWS.indexed_reuqest_param. *thanks Edward Muller*
*   include the nextToken in the body. *thanks Edward Muller*
*   complete Request param support. *thanks Edward Muller*
*   refactor to use Fog::AWS.indexed_request_param. *thanks Edward Muller*
*   the old parser was not working properly. *thanks Edward Muller*
*   All directories.create on us-east-1. *thanks Edward Muller*
*   us-west-2 default ami. *thanks Edward Muller*
*   some small fixups. *thanks Edward Muller*
*   make the aws region accessible. *thanks Edward Muller*
*   Fog::Compute::Server#private_key=. *thanks Edward Muller*
*   Fog::Compute::Server#sshable?. *thanks Edward Muller*
*   ssh/run optionally takes a block. *thanks Edward Muller*
*   Cleanup after talking to `@dpiddy.` *thanks Edward Muller*
*   return '' not nil. *thanks Edward Muller*
*   Revert "Add debug option to Fog::Compute::Server#ssh". *thanks Edward Muller*
*   Mock stop_instances. *thanks Edward Muller*
*   Mock aws compute start_instances. *thanks Edward Muller*
*   Don't duplicate effort. *thanks Edward Muller*
*   Add ssh_port to Fog::Compute::Server. *thanks Edward Muller*
*   Generalize NoLeak Inspector for Fog::Service. *thanks Edward Muller*
*   Don't leak HP cdn & storage. *thanks Edward Muller*
*   Make aws compute server retry SSH on EHOSTUNREACH. *thanks Eric Boehs*
*   Copied auth token reauthentication from rackspace|compute. *thanks Eric Hankins*
*   https://github.com/fog/fog/issues/810 -  Add ENI support by maf23. *thanks Eric Stonfer*
*   minor fix to ENI tests. *thanks Eric Stonfer*
*   VPC ELBs, Tests, and the introduction of the InternetGateway object. *thanks Eric Stonfer*
*   clean up conflict. *thanks Eric Stonfer*
*   this adds the dhcp_options object and associated operations. *thanks Eric Stonfer*
*   merge upstream. *thanks Eric Stonfer*
*   forgot to commit dhcp_options tests. *thanks Eric Stonfer*
*   fix describe_volume_status parser. *thanks Eric Stonfer*
*   add some more explanation to the server creation process. *thanks Eric Stonfer*
*   testing. *thanks Eugene Howe*
*   added requests and models for compute_pools. *thanks Eugene Howe*
*   changed to urn:tmrk:eCloudExtensions-2.8. *thanks Eugene Howe*
*   require compute pool to be specified on vapp creation. *thanks Eugene Howe*
*   set default value for computePool on vapp creation. *thanks Eugene Howe*
*   Made computePool an optional parameter, specs now pass without issue. *thanks Eugene Howe*
*   Removed non-functioning Mock classes. *thanks Eugene Howe*
*   fixed method name. *thanks Eugene Howe*
*   start an instance with an IAM profile and access the credentials. *thanks Frederick Cheung*
*   add new iam requests to support iam roles. *thanks Frederick Cheung*
*   request tests for the new iam role requests. *thanks Frederick Cheung*
*   test credential fetching. *thanks Frederick Cheung*
*   use excon rather than net/http. *thanks Frederick Cheung*
*   remove stray multijson require. *thanks Frederick Cheung*
*   fix errant use of net/http. *thanks Frederick Cheung*
*   Add debug option to Fog::Compute::Server#ssh. *thanks Gabriel Horner*
*   Correct docs for change_resource_record_sets. *thanks Gavin Sandie*
*   add cc2.8xlarge AWS flavor. *thanks Ian Downes*
*   Fix user-data attribute name. *thanks Igor Bolotin*
*   Refactor AWS Directory. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Fix indentation warning. *thanks James Herdman*
*   Remove unnecessary full path usage with require. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused accessor. *thanks James Herdman*
*   Silence warning regarding splat operator. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Silence warnings about potentially private attribute. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Silence warning about potentially private attribute. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove duplicate require. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove absolute path when requiring. *thanks James Herdman*
*   Remove unused variable. *thanks James Herdman*
*   Remove duplicate Mock class definition. *thanks James Herdman*
*   implement Fog::SSH::Mock#run. *thanks Jason Hansen & Josh Lane*
*   add a method to IPAddr instead of breaking a useful one. *thanks Jesse Newland*
*   Adjusts regex to fix issues with S3 paths that include periods. *thanks John Feminella*
*   fix response-cache-control type for AWS signed urls. *thanks John Nishinaga*
*   remove FOG_PROVIDER env override. *thanks Josh Lane*
*   more robust resource pool discovery. *thanks Justin Clayton*
*   Removed duplicate property :ips on server. *thanks Kevin Chan*
*   Fixes invalid call to #resize, should be #resize_machine. *thanks Kevin Chan*
*   Fixed #875: Loosen multi_json version. *thanks Kevin Menard*
*   Bad string replace. *thanks Kevin Menard*
*   Actually call the new MultiJSON 1.3.2 API methods. *thanks Kevin Menard*
*   Rename dd_belatedpng.js to dd_belatedpng.min.js. *thanks Laurent Bigonville*
*   Add non-minified javascript files used in docs/ (#939). *thanks Laurent Bigonville*
*   Catch Errno::ETIMEDOUT timeout error when connecting to a freshly created EC2 machine. *thanks Marc Seeger*
*   fix get, all, and all!. *thanks Michael Keirnan*
*   Make `.irbrc` service agnostic. *thanks Nelvin Driz*
*   Nested Credentials with Array gets flattened; restrict flatten to 1L. *thanks Nelvin Driz*
*   Allow for stringified options keys. *thanks Nikita Pomyashchiy*
*   add supports for defining/extracting libvit boot order. *thanks Ohad Levy*
*   libvirt volume sizes are in GB, ensuring both requests and setters are in GB. *thanks Ohad Levy*
*   adds deprecation on vnc_port. *thanks Ohad Levy*
*   monitoring-state is enabled or disabled, if enabled returns true. *thanks Ozgur Akan*
*   reserved instances hourly cost was returning empty. *thanks Ozgur Akan*
*   Modify url regexp to handle periods in bucket names. *thanks Parker Selbert*
*   Tag generated model tests with string not symbol. *thanks Paul Thornthwaite*
*   added missing server attributes for openstack compute model. *thanks Pedro Perez*
*   openstack: extended list_servers and list_server_detail to allow all_tenants param. *thanks Pedro Perez*
*   depend on excon >= 0.13.0. *thanks Prashant Nadarajan*
*   use pessimistic gem version constraint for excon (~>0.14.0). *thanks Prashant Nadarajan*
*   aim users model and nested model policy. *thanks Rodrigo Estebanez*
*   IAM access_key model implemented. *thanks Rodrigo Estebanez*
*   get_user Mock implemented. Basic shindo user_tests added. *thanks Rodrigo Estebanez*
*   Refactor aim modeling for nested models (policies and access keys). *thanks Rodrigo Estebanez*
*   shindo tests for IAM models: users, policies and access_keys. Mock implementation for get_user_policy. *thanks Rodrigo Estebanez*
*   `@users` -> `@user.` Clean up the `@user` after the policies and access_keys test. *thanks Rodrigo Estebanez*
*   Fix encoding issue: https://github.com/fog/fog/pull/189. *thanks Rodrigo Estebanez*
*   aim users model and nested model policy. *thanks Rodrigo Estebanez*
*   IAM access_key model implemented. *thanks Rodrigo Estebanez*
*   get_user Mock implemented. Basic shindo user_tests added. *thanks Rodrigo Estebanez*
*   Refactor aim modeling for nested models (policies and access keys). *thanks Rodrigo Estebanez*
*   shindo tests for IAM models: users, policies and access_keys. Mock implementation for get_user_policy. *thanks Rodrigo Estebanez*
*   `@users` -> `@user.` Clean up the `@user` after the policies and access_keys test. *thanks Rodrigo Estebanez*
*   Fix encoding issue: https://github.com/fog/fog/pull/189. *thanks Rodrigo Estebanez*
*   For some reason, there was a missing comma in the mock class. *thanks Rodrigo Estebanez*
*   Fix get_user_policy. The actual AWS data has to be in a ['Policy'] hash section. *thanks Rodrigo Estebanez*
*   add IAM mocking for get_group method. *thanks Rodrigo Estebanez*
*   add IAM mocking for get_group method. *thanks Rodrigo Estebanez*
*   Add new HP providers for Object Storage, Compute and CDN services. *thanks Rupak Ganguly*
*   Be sure to reload when checking for a started spot instance, also add private/public key options into spot_requests, then set those on the server when loaded. *thanks Ryan Stout*
*   Use spot request's public_key when setting up keypair. *thanks Ryan Stout*
*   ensure apiKey and command are included in parameter sorting. *thanks Sean Caffery*
*   * [xenserver|compute] initial release. *thanks Sergio Rubio*
*   * Added VIF model and collection tests     * added network and server wrappers to VIF model. *thanks Sergio Rubio*
*   * Added VIF collection Shindo tests. *thanks Sergio Rubio*
*   * Added PIFs collection Shindo tests. *thanks Sergio Rubio*
*   * Added VBD Shindo tests     * added server wrapper to VBD model. *thanks Sergio Rubio*
*   * Added Network collection Shindo tests     * Fixed PBD and PIF tests descriptions. *thanks Sergio Rubio*
*   * Added Pool and StorageRepository models and collections Shindo tests     * Added missing attributes to Pool and StorageRepository models. *thanks Sergio Rubio*
*   * Define missing InvalidLogin exception     * Add login tests. *thanks Sergio Rubio*
*   * Added custom_templates and templates methods to Host model. *thanks Sergio Rubio*
*   * Added more tests and extended existing ones     * Added missing exceptions NotFound and RequestFailed     * connection.request now raises exception if request failed     * refactored most get_* request into get_record and get_records     * Compute.default_template more robust     * Base parser now replaces OpaqueRef:NULL with nil     * create_server request fixes. *thanks Sergio Rubio*
*   * Added some more tests     * Lots of fixes and some refactoring. *thanks Sergio Rubio*
*   * Fix Servers.templates method. *thanks Sergio Rubio*
*   * Added clone_server request. *thanks Sergio Rubio*
*   * Added create_vif tests     * Server.save  now properly creates additional VIFs when required     * Added create_vif_custome request to create VIFs with custom params. *thanks Sergio Rubio*
*   * Added Vif.destroy and destroy_vif request     * add :auto_start parameter to Server.save. *thanks Sergio Rubio*
*   * Added create_vdi request     * Added missing VDI methods and attributes. *thanks Sergio Rubio*
*   * Added missing VBD operations. *thanks Sergio Rubio*
*   * Added set_attribute request and tests     * Added missing PV_bootloaer attribute to Server     * Added Server.set_attribute method and tests. *thanks Sergio Rubio*
*   * Added create_vbd and provision_server requests     * Do not provision server when :auto_start is false     * Add Server.provisio method     * Add VBD.save method. *thanks Sergio Rubio*
*   * renamed some tests     * Added missing VDI attributes and methods     * added create/destroy request tests     * Added valid_ref? test helper     * Fixes in get_record_tests. *thanks Sergio Rubio*
*   * Added missing attributes to Server model     * Added create_server_raw request and tests     * Added VIF.save action     * more tests. *thanks Sergio Rubio*
*   * Fix: do not try to retrive guest_metrics when guest_metrics ref is nil     * ruby 1.8.7 compatibility fixes     * Sane defaults for create_server_raw request. *thanks Sergio Rubio*
*   * Added new scan_sr request     * Added StorageRepository.scan method     * set_attribute request is now generic and can be used by any model     * Added VDI.set_attribute method. *thanks Sergio Rubio*
*   * [xenserver|compute] set_attribute request now accepts var args       - added new tests. *thanks Sergio Rubio*
*   updating gitignore for eclipse settings. *thanks Spencer Dillard*
*   first pass at updates for VPC. *thanks Spencer Dillard*
*   updating for SSL ciphers and protocols. *thanks Spencer Dillard*
*   updating to master. *thanks Spencer Dillard*
*   regularize examples showing use of AWS access keys. *thanks Stephen Bannasch*
*   Use MultiJSON #dump and #load rather than #encode and #decode. *thanks Steve Smith*
*   Add support for ports in AWS storage URLs. *thanks Tim Carey-Smith*
*   Mock implementations for SCP upload and download. *thanks Tom Mornini*
*   add Linode Mock classes to request primitives. *thanks Wes Morgan*
*   make Mock#linode_disk_delete return the response object. *thanks Wes Morgan*
*   make Mock#linode_disk_list return the response object. *thanks Wes Morgan*
*   use kernel_id for mocked kernel, not stackscript_id. *thanks Wes Morgan*
*   Adds new method delete_notification_configuration which allows you     notifications created by put_notification_configuration. *thanks Zuhaib Siddique*
*   Fix for stacks that have capabilities. Without this the parser misinterprets stacks with capabilities set. *thanks atlantacs*
*   volume(s) are not considered to be universally available. *thanks geemus*
*   catch passing an invalid openstack_tenant. *thanks mattray*
*   addresses['internet'] (like on TryStack.org) supported and public and private_ip_address now work. *thanks mattray*
*   don't assume 'internet' for addresses. *thanks mattray*
*   Added offering type for reserved instances response. *thanks questionnet*

#### [oVirt]
*   added volumes to server and template. *thanks Amos Benari*
*   added volume size in GB accessor. *thanks Amos Benari*
*   fixed create_vm and get_virtual_machine requests mock implementation. *thanks Amos Benari*

#### [openstack]
*   Fix create snapshot. *thanks Ferran Rodenas*
*   Match both OS API 1.1 and v2 since they are the same. *thanks Josh Kearney*
*   Update Reinitialization Process of Existing Auth Token. *thanks Nelvin Driz*
*   Add Export of Credentials. *thanks Nelvin Driz*
*   Wrong instance variables accessed for #credentials. *thanks Nelvin Driz*
*   Update Authentication through X-Auth-Token. *thanks Nelvin Driz*
*   Update mocks for login and identity request #get_user_by_id. *thanks Nelvin Driz*
*   Fix authentication without specifying tenant name. *thanks Nelvin Driz*
*   Make current_user and current_token accessible to services. *thanks Nelvin Driz*
*   Fix Authentication as well as Fog::JSON call bugs. *thanks Nelvin Driz*
*   Raise error when no tenant is found for the user logging in. *thanks Nelvin Driz*
*   Ensure password sent is of type string. *thanks Nelvin Driz*
*   Modify authentication process. *thanks Philip Mark Deazeta*

#### [openstack|compute]
*   Add requests and tests for security groups. *thanks Alfonso Juan Dillera*
*   Add requests, models and tests for keypairs. *thanks Alfonso Juan Dillera*
*   Add requests, models and tests for address     management. *thanks Alfonso Juan Dillera*
*   Add requests, models and tests for address     management. *thanks Alfonso Juan Dillera*
*   Add flavor CRUD. *thanks Alfonso Juan Dillera*
*   Add auth_token. *thanks Alfonso Juan Dillera*
*   Added request for boot_from_snapshot. *thanks Alfonso Juan Dillera*
*   Added id attribute to the keypair. *thanks Alfonso Juan Dillera*
*   Update fetching of addresses and added fetching for address pools. *thanks Alvin Garcia*
*   Fixed creating image of a server. *thanks Alvin Garcia*
*   Added requests for quota. *thanks Alvin Garcia*
*   Initial extension support for addresses. *thanks Hunter Nield*
*   Initial extension support for key pairs. *thanks Hunter Nield*
*   Initial extension support for security groups. *thanks Hunter Nield*
*   Added Address models. *thanks Hunter Nield*
*   Added key pair models. *thanks Hunter Nield*
*   added security group models. *thanks Hunter Nield*
*   Updates to server model. *thanks Hunter Nield*
*   Added list/get support for /os-hosts. *thanks Hunter Nield*
*   Add Tenants and Fix Authentication Implementation. *thanks Nelvin Driz*
*   Fix Requests on Compute. *thanks Nelvin Driz*
*   General Cleanup and Update. *thanks Nelvin Driz*
*   Fix Compute Identity Endpoint Credential Export. *thanks Nelvin Driz*
*   Add Identity Enpoint to Recognized Init Parameters. *thanks Nelvin Driz*
*   Update requests and response of server actions. *thanks Nelvin Driz*
*   Fix Bug on Key Pair Mock. *thanks Nelvin Driz*
*   Update Mocks for Volumes. *thanks Nelvin Driz*
*   Update Mocks for Security Groups and Volumes. *thanks Nelvin Driz*
*   Add Instance Name to Fog. *thanks Nelvin Driz*
*   Update Image Mocks. *thanks Nelvin Driz*
*   Update List Security Groups to list those assigned to a server. *thanks Nelvin Driz*
*   Assert Timezone to UTC and fix format for OS on `get_usage`. *thanks Nelvin Driz*
*   Added get_usage function, mocks, tests. *thanks Philip Mark Deazeta*
*   Added get server volumes request. *thanks Philip Mark M. Deazeta*
*   Added key_pair and security_groups options int create server requrest. *thanks Philip Mark M. Deazeta*
*   added key_name and security_groups in boot from snapshot request. *thanks Philip Mark M. Deazeta*
*   authenticate_v2 fixes. *thanks Sergio Rubio*

#### [openstack|identity]
*   Added current user id. *thanks Alfonso Juan Dillera*
*   Updated current user id for identity. *thanks Alfonso Juan Dillera*
*   Keystone Roles. *thanks Alvin Garcia*
*   Keystone Roles and Users. *thanks Alvin Garcia*
*   Update users collections and model. *thanks Alvin Garcia*
*   Update users model initialization and save. *thanks Alvin Garcia*
*   Fixed users fetching. *thanks Alvin Garcia*
*   Rough implementation of the Keystone API (untested). *thanks Hunter Nield*
*   Correction in Roles#all method. *thanks Mark Maglana*
*   Express the "add user role" intent more clearly. *thanks Mark Maglana*
*   Fix Authentication Implementation. *thanks Nelvin Driz*
*   Update Tenants. *thanks Nelvin Driz*
*   Update Tenants (Complete CRUD). *thanks Nelvin Driz*
*   Fix Identity Authentication Conditions on Endpoint     Detection. *thanks Nelvin Driz*
*   Add User List and Delete User Mocks. *thanks Nelvin Driz*
*   Update Fog to Accomodate Tenant Deletion Workaround     Workflow. *thanks Nelvin Driz*
*   Fix status code expectation. *thanks Nelvin Driz*
*   Added function to add user to a tenant. *thanks Philip Mark Deazeta*
*   Added function to add user to a tenant. *thanks Philip Mark Deazeta*
*   fixes for mocks. *thanks geemus*

#### [openstack|image]
*   Added set_tenant. *thanks Alvin Garcia*
*   Added copy_from attribute. *thanks Alvin Garcia*
*   Update Image Service Authentication Options. *thanks Nelvin Driz*
*   Added image service, model and request. *thanks Philip Mark Deazeta*
*   Added test for models and request. *thanks Philip Mark Deazeta*
*   Added image module, model and request. *thanks Philip Mark Deazeta*
*   Image Model Updates. *thanks Philip Mark Deazeta*
*   Refactor Dynamic Methods on Image Model. *thanks Philip Mark Deazeta*

#### [openstack|volume]
*   Volume Endpoints Support. *thanks Marjun Pagalan*
*   Volume Snapshot CRUD. *thanks Marjun Pagalan*
*   Volume attach/detach to Server. *thanks Marjun Pagalan*
*   Added volume service requests. *thanks Philip Mark M. Deazeta*
*   fix on module name. *thanks Philip Mark M. Deazeta*
*   Added volume model. *thanks Philip Mark M. Deazeta*

#### [ovirt]
*   fixed list storage domain test. *thanks Amos Benari*

#### [rackspace|compute]
*   fix rackspace server compare. *thanks Josh Lane & Jason Hansen*
*   default images. *thanks Josh Lane & Jason Hansen*
*   Images#all returns data. *thanks Josh Lane & Jason Hansen*
*   fixes for mock images. *thanks geemus*

#### [rackspace|lb]
*   added support for algorithm on create. *thanks Brian Hartsock*
*   fixed broken tests due to API contract changes. *thanks Brian Hartsock*

#### [rackspace|loadbalancers]
*   fixed broken tests. *thanks Brian Hartsock*

#### [rackspace|storage|file]
*   copy method now use the options hash and apply content type. *thanks Matthias Gröbner*

#### [rackspace|storage|files]
*   fix iteration. *thanks Matthias Gröbner*

#### [slicehost]
*   remove (now deprecated) slicehost support. *thanks geemus*

#### [storage|aws]
*   fix location stuff to allow creating new buckets properly. *thanks geemus*

#### [vcloud]
*   Remove some un-needed debug information. *thanks Lincoln Stoll*

#### [vpc-fixes]
*   AWS security group model + VPC. *thanks Sean Porter*

#### [vsphere]
*   force poweroff of instance of vmware tools are not installed. *thanks Ohad Levy*
*   adds memory and cpu server attributes. *thanks Ohad Levy*
*   adds support to get and set vnc console. *thanks Ohad Levy*

#### [xenserver]
*   Added missing Server.tags attribute. *thanks Sergio Rubio*
*   fix tags to skip tests without credentials. *thanks geemus*


## 1.3.1 03/27/2012
*Hash* f0f692456956fe2e414ef8205d0268259901644a

Statistic     | Value
------------- | --------:
Collaborators | 32
Downloads     | 527366
Forks         | 392
Open Issues   | 27
Watchers      | 1901

**MVP!** George Scott

#### [aws|dns]
*   Preserves change_id.  Support for checking sync status via reload. *thanks George Scott*
*   Changed #insync? to #ready?. *thanks George Scott*

#### [ibm]
*   avoid using constants (Rails loads files multiple times, issue #807). *thanks Decklin Foster*
*   Make usage of #state rather than #status consistent. *thanks Decklin Foster*

#### [ibm|compute]
*   Add clone/destroy methods and tests to Image. *thanks Decklin Foster*
*   Add request test for list_vlans and fix mock. *thanks Decklin Foster*

#### [ibm|storage]
*   Restore storage_area, platform_version, clone_status Volume attributes. *thanks Decklin Foster*

#### [misc]
*   Allow custom headers in Storage#put_object_url. *thanks Jacob Mattingley*
*   Use https_url instead of deprecated url for put_object_url. *thanks Jacob Mattingley*
*   Adding Vlan class to IBM SmartCloud. *thanks Joe Kinsella*
*   bump excon dep to get jruby openssl fixes. *thanks geemus*

#### [storage]
*   properly update content-type at save time for file models. *thanks geemus*


## 1.3.0 03/21/2012
*Hash* f78afe98242a60ae4dbbfcd8c5ab67ba71c6d773

Statistic     | Value
------------- | --------:
Collaborators | 32
Downloads     | 513974
Forks         | 387
Open Issues   | 24
Watchers      | 1893

**MVP!** Decklin Foster

#### [aws|cloud_watch]
*   GitHub Edit! s/prodide/provide/ :v:. *thanks Dylan Egan*

#### [aws|simpledb]
*   fix region/host for us-east-1. *thanks geemus*

#### [ibm]
*   Added Mocking and Tests. *thanks Carl Hicks*
*   Moar convenience methods for servers. *thanks Carl Hicks*
*   Update model for Volume. *thanks Carl Hicks*
*   Added request tests for addresses. *thanks Carl Hicks*
*   Initial IBM SmartCloud support. *thanks Decklin Foster*
*   Add Location model and requests. *thanks Decklin Foster*
*   Rename collection requests get->list so we have get_foo and list_foos. *thanks Decklin Foster*
*   Don't need json_body, so we can simplify requests; remove unused params. *thanks Decklin Foster*
*   Pass optional params to requests with hashes. *thanks Decklin Foster*
*   Add a InstanceType model, returned as part of Images. *thanks Decklin Foster*
*   Rename model test files into compute, storage dirs. *thanks Decklin Foster*
*   Remove trailing whitespace. *thanks Decklin Foster*
*   Update tests to match model arguments (attribs hash) and lower-level request methods. *thanks Decklin Foster*
*   Update mocks to reflect moving volume models from from compute to storage. *thanks Decklin Foster*
*   Add some missing mocks, fix list_instances. *thanks Decklin Foster*
*   Raise NotFound in mock instead of returning a 404. *thanks Decklin Foster*
*   Fix form_encode to stringify args (e.g. booleans) to URI.escape. *thanks Decklin Foster*
*   Typos in state names and status vs. state. *thanks Decklin Foster*
*   Fix key model for passing public_key, add setting/testing whether key is default. *thanks Decklin Foster*
*   Setting default key returns success, not key name. *thanks Decklin Foster*
*   Typo, assignment instead of equality, made some tests incorrectly pass. *thanks Decklin Foster*
*   Flesh out modify_instance and modify_key for different modes. *thanks Decklin Foster*
*   Restarting should return success, changing expiration should only return time. *thanks Decklin Foster*
*   Delete instance mock should return success. *thanks Decklin Foster*
*   Remove IBM from flavors tests. *thanks Decklin Foster*
*   Make names used in tests unique using current time. *thanks Decklin Foster*
*   Add vlan_id attrib so that it can be used in creating an instance. *thanks Decklin Foster*
*   Return nil for public_hostname if primary_ip unset (e.g. state is Failed). *thanks Decklin Foster*
*   Change default location and image ID. *thanks Decklin Foster*
*   Rename ibm_user_id -> ibm_username. *thanks Decklin Foster*
*   Create temporary keys in tests that need to create instances. *thanks Decklin Foster*
*   servers are not sorted, don't assume we can just take the last. *thanks Decklin Foster*
*   create_image should do a PUT, not a POST, and needs 'state' param. *thanks Decklin Foster*
*   Correct spelling of test volume format ('RAW') and fix parameter typo. *thanks Decklin Foster*
*   Rename data -> body. *thanks Decklin Foster*
*   Don't reboot or immediately expire, interferes with other tests. *thanks Decklin Foster*
*   Use Raleigh location for tests. *thanks Decklin Foster*
*   Nullable formats for attributes that may not be returned. *thanks Decklin Foster*
*   Set expire a few seconds in the future since it takes a while to process. *thanks Decklin Foster*
*   Return nil if instance_id is nil. *thanks Decklin Foster*
*   Can't access Fog::Compute::IBM::Location class from here, just check if ID returned. *thanks Decklin Foster*
*   servers.length will include already existing servers. *thanks Decklin Foster*
*   Add state and ready? method to Image. *thanks Decklin Foster*
*   Change public key format. *thanks Decklin Foster*
*   vlan is part of primaryIP. *thanks Decklin Foster*
*   Rename root_only -> is_mini_ephemeral. *thanks Decklin Foster*
*   Description is mandatory. *thanks Decklin Foster*
*   Wait for instance to be ready before deleting it or creating image. *thanks Decklin Foster*
*   Add state/ready? methods for Address. *thanks Decklin Foster*
*   Expiration time should be epoch in ms. *thanks Decklin Foster*
*   launched_at convenience method. *thanks Decklin Foster*
*   Don't set server to nil. *thanks Decklin Foster*
*   Set a longer timeout on all wait_for calls. *thanks Decklin Foster*
*   Generated key needs different name, supplied key only returns success. *thanks Decklin Foster*
*   Invalid instance creation will return a 412 and thus raise PreconditionFailed. *thanks Decklin Foster*
*   Don't calculate expiration time until ready to make the request. *thanks Decklin Foster*
*   Fix volume formats and mocks. *thanks Decklin Foster*
*   Wait for volume to be ready before deleting. *thanks Decklin Foster*
*   Mark volume attach/detach pending, won't create instance. *thanks Decklin Foster*
*   Return pending if provisioning times out in the real tests. *thanks Decklin Foster*
*   adding documentation. *thanks Wyatt Walter*
*   add bin helpers for storage. *thanks geemus*

#### [misc]
*   ovirt added support for 'set vm ticket'.     This api call is needed for openning a console to the server. *thanks Amos Benari*
*   wrangled security tests into working. *thanks Eric Stonfer*
*   Changes to the security group handling:     * CreateSecurityGroup now includes the group id in the reply, this       patch makes the code store this     * The patch also changes the delete call to use the group id if       present (since you must use the id when deleting VPC groups). *thanks MaF*
*   Changes to the security group handling:     * CreateSecurityGroup now includes the group id in the reply, this       patch makes the code store this     * The patch also changes the delete call to use the group id if       present (since you must use the id when deleting VPC groups)     * Fix teh security group mock and test code to handle this new behavior. *thanks MaF*
*   Removed merge commit. *thanks MaF*

#### [release]
*   add Kevin Menard to future MVP exclusion list. *thanks geemus*

#### [storage|aws]
*   fix hardcoded host in get_object_http(s)_url methods. *thanks geemus*


## 1.2.0 03/19/2012
*Hash* 70e0f48fa446dbf233ae31c4f055eb26ea2dadd1

Statistic     | Value
------------- | --------:
Collaborators | 30
Downloads     | 508132
Forks         | 384
Open Issues   | 23
Watchers      | 1874

**MVP!** Kevin Menard

#### [AWS]
*   Compute: The security group parser was not parsing groupid properly. *thanks Christopher Oliver*

#### [AWS|DynamoDB]
*   table requests. *thanks geemus*
*   cleanup/fixes for tables. *thanks geemus*
*   item requests. *thanks geemus*
*   update item should not be idempotent when an action is specified. *thanks geemus*
*   fix for UpdateItem idempotency. *thanks geemus*
*   first pass at query/scan requests. *thanks geemus*
*   ConsumedCapacityUnits should be a Float. *thanks geemus*
*   add missing pending for mocked tests. *thanks geemus*

#### [AWS|ELB]
*   Added support for InstanceProtocol to listeners. *thanks James Stremick*
*   Updating listener and LB tests to include InstancePort checks. *thanks James Stremick*

#### [AWS|Storage]
*   versioning related fixes copy_object mocks. *thanks geemus*
*   fix for put_bucket_website mock. *thanks geemus*
*   remove redundant mock setup in tests #731. *thanks geemus*

#### [AWS|storage]
*   fix for versioned copy_object. *thanks geemus*

#### [Brightbox]
*   Updates to format tests. *thanks Paul Thornthwaite*
*   Updated Server output format. *thanks Paul Thornthwaite*
*   Updated format test to use correct link name. *thanks Paul Thornthwaite*
*   Updated Image format for min_ram attribute. *thanks Paul Thornthwaite*
*   Updated LoadBalancer format to include listeners in listing. *thanks Paul Thornthwaite*
*   Updated format for nested firewall policies. *thanks Paul Thornthwaite*
*   Merge in various spec corrections. *thanks Paul Thornthwaite*
*   Update format test to not fail on new attributes in JSON. *thanks Paul Thornthwaite*
*   Load balancer listener timeouts are now reported. *thanks Paul Thornthwaite*
*   Correct server snapshot test. *thanks Paul Thornthwaite*

#### [Compute|OpenStack]
*   match auth response to stable/diablo branch of keystone. *thanks Todd Willey*

#### [Rackspace|Storage]
*   set put_object to idempotent. *thanks geemus*

#### [aws]
*   add sts helper. *thanks geemus*

#### [aws|compute]
*   Fixed failing instance tests. *thanks Christopher Oliver*
*   Update API version and support new DescribeInstanceStatus format. *thanks Dan Peterson*
*   Fix allocate_address mocking. *thanks Dan Peterson*
*   Mock detach_volume should raise proper error if volume is not attached. *thanks Dan Peterson*
*   added group id to security group parser and model. *thanks bdorry*
*   added security group get by id method. *thanks bdorry*

#### [aws|dns]
*   Record identity is 'Name'. *thanks Aaron Suggs*
*   Add Record#modify method. *thanks Aaron Suggs*
*   Add model tests. *thanks Aaron Suggs*
*   add test for Record#modify. *thanks Aaron Suggs*
*   Parse IsTruncated as boolean in list_resource_record_set. *thanks Aaron Suggs*
*   Add support for aliasing records to Elastic Load Balancers (API 2011-05-05). *thanks James Miller*

#### [aws|elb]
*   start working on policies. :v:. *thanks Dylan Egan*
*   create policies, describe policies, fix old mocking and yup. :v:. *thanks Dylan Egan*
*   PolicyNotFound. :v:. *thanks Dylan Egan*
*   remove test debugging. :v:. *thanks Dylan Egan*
*   actually raise a PolicyNotFound. :v:. *thanks Dylan Egan*
*   InstanceProtocol support. :v:. *thanks Dylan Egan*

#### [aws|fog]
*   crapiness and hacks. :v:. *thanks Dylan Egan*

#### [aws|iam]
*   Mock upload_server_certificate errors if private key is not RSA. *thanks Dan Peterson*
*   P. :v:. *thanks Dylan Egan*

#### [aws|rds]
*   Mock DB snapshot requests. *thanks Aaron Suggs*
*   Enabled model tests that pass when mocking. *thanks Aaron Suggs*

#### [aws|storage]
*   Simple multipart uploads; supports files > 5GB. *thanks Aaron Suggs*
*   Automatically abort multipart uploads on exceptions. *thanks Aaron Suggs*
*   Add mock for Fog::Storage::AWS#put_bucket_website. *thanks Garret Alfert*
*   Handle S3 object deletions in the face of versioning. *thanks Kevin Menard*
*   Return the object version in the request header and set an attribute value in the model. *thanks Kevin Menard*
*   Allow options to be passed to the destroy method, facilitating passing of versionId. *thanks Kevin Menard*
*   Added ability to control bucket versioning from Directory model. *thanks Kevin Menard*
*   Added the ability to fetch a list of versions from a file. *thanks Kevin Menard*
*   Allow passing of options to fetching versions. *thanks Kevin Menard*
*   Added the pagination offset params to the get_object_bucket_versions parser. *thanks Kevin Menard*
*   Added the MfaDelete value to the get_bucket_versioning parser. *thanks Kevin Menard*
*   Fix put bucket website test, request returns not found when the bucket does not exist. *thanks Peter Weldon*
*   Add bucket lifecycle / object expiration requests. *thanks Peter Weldon*
*   make head_object idempotent. *thanks geemus*
*   direct https urls to subdomains even with dots     this may result in ssl warnings, but that seems better than the alternative (redirects)     see #611. *thanks geemus*

#### [aws|storage|test]
*   use a random directory key; prevent collision. *thanks Aaron Suggs*
*   Mark multipart upload test as pending. *thanks Aaron Suggs*
*   Added mock support for setting and retrieving versioning on a bucket. *thanks Kevin Menard*
*   Added in versioning support for S3 objects, sans deletion markers. *thanks Kevin Menard*
*   Track if the version is the latest or not. *thanks Kevin Menard*
*   Basic handling of version-id-marker. *thanks Kevin Menard*
*   Added the ability to get_object by versionId. *thanks Kevin Menard*
*   Added S3 versioning support for delete_object. *thanks Kevin Menard*
*   Deal with suspended buckets properly. *thanks Kevin Menard*
*   Added request tests for put_bucket_versioning and get_bucket_versioning. *thanks Kevin Menard*
*   Added tests for get_bucket_object_versions. *thanks Kevin Menard*
*   Added request test for get_object with versioning. *thanks Kevin Menard*
*   Added request tests for delete_object with versioning. *thanks Kevin Menard*
*   Added failing request test for delete_object with versioning. *thanks Kevin Menard*
*   Added in some file and directory model tests. *thanks Kevin Menard*
*   Added model tests for versioning Directory and File models. *thanks Kevin Menard*
*   Added tests for the Version model. *thanks Kevin Menard*
*   Added versioning test for Files collection. *thanks Kevin Menard*
*   Added versioning tests for Versions collection. *thanks Kevin Menard*
*   Added versioning test for Files#head. *thanks Kevin Menard*
*   Removed a commented-out test. *thanks Kevin Menard*
*   Make sure tests pass with both mocking enabled and disabled. *thanks Kevin Menard*
*   Fixed a regression with mocked get_bucket requests, due to a change in the mock data ordering. *thanks Kevin Menard*
*   Fixed handling of options in mocked get_bucket_object_versions. *thanks Kevin Menard*
*   Replaced random ETag implementation with MD5, per S3 docs. *thanks Kevin Menard*

#### [aws|sts]
*   make get_*_token requests idempotent. *thanks geemus*

#### [beanstalk]
*   avoid one remaining error with mocked tests. *thanks geemus*

#### [cloudstack]
*   Fix warning in ruby 1.8.7. *thanks Aaron Suggs*
*   added additional networking support and volume management commands. *thanks Brian Dorry*
*   added unit tests. *thanks Brian Dorry*
*   skip ssl verification. *thanks geemus*

#### [cloudstack|compute]
*   merged in upstream. *thanks bdorry*
*   added ssh key support, snapshot policy support. *thanks bdorry*
*   added update resource count action. *thanks bdorry*

#### [compute|aws]
*   fix for describe_images parser that accidently split records. *thanks geemus*
*   fix error in describe_security_groups parser     closes #678. *thanks geemus*

#### [compute|cloudstack]
*   added basic cloudstack list support. *thanks bdorry*
*   added user management support. *thanks bdorry*
*   added domain management support. *thanks bdorry*
*   added domain management support, added documentation links to existing cloudstack requests. *thanks bdorry*

#### [core]
*   no need to expand the already exanded __LIB_DIR__. *thanks geemus*
*   update connection to use new excon response_block format. *thanks geemus*

#### [docs]
*   Update GitHub repository references from geemus/fog to fog/fog. *thanks Benjamin Manns*

#### [dynect|dns]
*   Pass zone.records.all options through to get_node_list. *thanks Dan Peterson*

#### [glesys|compute]
*   fix for changes in api. *thanks Anton Lindström*

#### [joyent|compute]
*   rename _test files to _tests for shindo. *thanks geemus*
*   make password required. *thanks geemus*
*   fix format of joyent to match real output and remove mock-only test. *thanks geemus*

#### [local|storage]
*   Fix Local::File deletion for Ruby 1.8. *thanks Benjamin Manns*
*   Add copy_object method to Local::Storage. *thanks Benjamin Manns*
*   Add copy method to Local::File. *thanks Benjamin Manns*

#### [misc]
*   whitespace. *thanks Aaron Suggs*
*   fix typo in comment. *thanks Aaron Suggs*
*   whitespace cleanup. *thanks Aaron Suggs*
*   Refactor to support ruby 1.8.7. *thanks Aaron Suggs*
*   Whoops, don't need to require digest/md5. *thanks Aaron Suggs*
*   whitespace. *thanks Aaron Suggs*
*   Adds Supprt for oVirt (http://ovirt.org). *thanks Amos Benari*
*   oVirt: Added tests to work on both real and mock. *thanks Amos Benari*
*   Removing duplicates from reservation's groupSet. *thanks Artem*
*   Remove coverage Rake task. *thanks Benjamin Manns*
*   Remove a step that referenced a private config file. *thanks Bob Briski*
*   updated cloudstack tests for user level permissions, added ssh key, disk offering, service offering, os type, security group tests. *thanks Brian Dorry*
*   Adding update_firewall_rule request. *thanks Caius Durling*
*   Correct an error with long keys where Base64.encode64 would add "\n" at 60 chars. *thanks Chris Hasenpflug*
*   Use gsub for Ruby 1.8.7 compatibility. *thanks Chris Hasenpflug*
*   Correct copy & paste error. *thanks Chris Hasenpflug*
*   implement #scp_download method to allow downloads in addition to uploads via scp. alias #scp method as #scp_upload. *thanks Christoph Schiessl*
*   tests for scp_download. *thanks Christoph Schiessl*
*   Removed various 'puts' statements... *thanks Christopher Oliver*
*   fix for free choice of region. *thanks Daniel Schweighoefer*
*   save the region in a instance variable. *thanks Daniel Schweighoefer*
*   rounding out API coverage in 'Virtual Machine section. *thanks David Nalley*
*   mock #create_user and #create_access_keys". *thanks Edward Muller*
*   fix typo. *thanks Edward Muller*
*   Enable Shindo tests for the mocked methods. *thanks Edward Muller*
*   Refactor mock data structure. *thanks Edward Muller*
*   mock #put_user_policy. *thanks Edward Muller*
*   Mock out #list_users. *thanks Edward Muller*
*   Mock #delete_user_policy. *thanks Edward Muller*
*   Move this is Mock.key_id and don't default the path. *thanks Edward Muller*
*   Add group mock data. *thanks Edward Muller*
*   Use #has_key? instead of #keys.include?. *thanks Edward Muller*
*   rework these to use #tap instead. Cleaner IMNSHO. *thanks Edward Muller*
*   Additional mocks. *thanks Edward Muller*
*   missing raise. *thanks Edward Muller*
*   DescribeVolumeStatus. *thanks Edward Muller*
*   Add code to support the creation and modification of security groups existing in a VPC. *thanks Eric Stonfer*
*   modified security group tests to accomodate the new security group data model.  Also allowed permissions to be nil in the security tests for groups with no ACLs. *thanks Eric Stonfer*
*   Change default for vpc_id from '' to nil. *thanks Eric Stonfer*
*   fixed a conditional that was assigining = rather than evaluating == in vsphere clone routine.  This resulted in cloning from folders always failing. *thanks Eric Stonfer*
*   Add the ability to create linked clones in vsphere. *thanks Eric Stonfer*
*   whitespace fix. *thanks Eric Stonfer*
*   whitespace fix. *thanks Eric Stonfer*
*   add a linked clone test scenario, set the vm_clone test to wait, and clean up old servers after the VM clone test. *thanks Eric Stonfer*
*   linked clone tests. *thanks Eric Stonfer*
*   This patch allows the ability to create 'blank' vms in vsphere. *thanks Eric Stonfer*
*   fix list_virtual_machines when using :folder. *thanks Eric Stonfer*
*   add vm reconfiguration functions for memory cpu / generic spec. *thanks Eric Stonfer*
*   add subnet and vpc info to instance gets. *thanks Eric Stonfer*
*   fixed a typo in vm_power_on_tests.rb. *thanks Eric Stonfer*
*   make eips useable in a VPC. *thanks Eric Stonfer*
*   associate EIPs in a vpc. *thanks Eric Stonfer*
*   update autoscaling groups to allow the use of recurrence, start and end times. *thanks Eric Stonfer*
*   realized that `@activity` was actually not used. *thanks Eric Stonfer*
*   fixed some whitespace issues in auto_scaling tests.  Fixed auto_scaling tests formats. *thanks Eric Stonfer*
*   add host based vmotion. *thanks Eric Stonfer*
*   basic VPC creation. *thanks Eric Stonfer*
*   [aws]Add in subnets. *thanks Eric Stonfer*
*   enable_metrics_collection requires a granularity argument (1Minute is the only legal value). *thanks Frederick Cheung*
*   New file additions for AWS Elastic Beanstalk support. *thanks George Scott*
*   Added beanstalk service to AWS Provider. *thanks George Scott*
*   Unit tests for beanstalk. *thanks George Scott*
*   Now sets pending when mocking for all beanstalk model tests. *thanks George Scott*
*   environment now uses name as identity. *thanks George Scott*
*   Added additional convenience methods to application. *thanks George Scott*
*   remove rubygems require from core.rb. *thanks Hemant Kumar*
*   Reset the alias_target hash for good measure. *thanks James Miller*
*   Add a test for ALIAS records. *thanks James Miller*
*   Cleanups and crazy long sleep to ensure ALIAS zone is found. *thanks James Miller*
*   Fix linked clone mocked test unhandled exception. *thanks Jeff McCune*
*   (maint) Whitespace and format only clean up. *thanks Jeff McCune*
*   added support for server-side encryption on s3. *thanks John Parker*
*   Switch from NewServers to BareMetalCloud for #773. *thanks John Wang*
*   Add deprecation warning. *thanks John Wang*
*   Fixed bug in SQS :receive_message mock. *thanks Joshua Krall*
*   Fixed a typo in the warning. *thanks Kashif Rasul*
*   One more typo fix. *thanks Kashif Rasul*
*   GH-690 Joyent Cloud Provider. *thanks Kevin Chan*
*   Credentials: cloudapi_* -> joyent_* for consistency. *thanks Kevin Chan*
*   Revert "[joyent|compute] make password required"     This reverts commit 6e93321e29e69cc863aa9d78cdcf1c83203a2fa7. *thanks Kevin Chan*
*   Fixes dataset tests. *thanks Kevin Chan*
*   - Fixes tests to run in both mock and non-mock mode      - Clean ups and fixes. *thanks Kevin Chan*
*   Cleanups + Fixes #get_machine test breaking when there are no machines. *thanks Kevin Chan*
*   cleanups + refactorings + better error reporting per joyent cloudapi spec. *thanks Kevin Chan*
*   Fixed #673: Zerigo DNS - update_host fails with some options. *thanks Kevin Menard*
*   Fixed a filename. *thanks Kevin Menard*
*   implement respond_to? corresponding to method_missing for VirtualBox and libvirt. *thanks Konstantin Haase*
*   Swap aws_access_key_id and aws_secret_access_key positions in hash to match typical usage convention. *thanks Kyle Drake*
*   When Exists boolean is not specified, this request is not idempotent. *thanks Lance Carlson*
*   Scan sort of acts like a GET request, which are idempotent. *thanks Lance Carlson*
*   Only do a 'head' on the file that we've copied - no need to go download it now, that would defeat the purpose. *thanks Lars Pind*
*   Improved support for SecurityGroup IDs. *thanks MaF*
*   We must create the VPC before we can create a security group in it. *thanks MaF*
*   Changed verify_permission_options in mocked version of authorize_security_group_ingress     to accept any ipProtocol for vpc groups.     Also changed the security group test to use protocol 42 when testing vpc security_groups. *thanks MaF*
*   Check if exception has a #response method before calling it, otherwise call #message. *thanks Manuel Meurer*
*   Fix sync_clock method, only rescue Excon::Errors::HTTPStatusError that are known to have a #response method, let all other exceptions bubble up. *thanks Manuel Meurer*
*   Updated excon to version ~>0.10.0. Closes #781. *thanks Marc Seeger*
*   include fission gem. *thanks Michael Brodhead & Shai Rosenfeld*
*   Move fission from reg dependency to dev dependency per comments on pull request #736. *thanks Michael Brodhead & Shai Rosenfeld*
*   adding required gem to run the tests. *thanks Ohad Levy*
*   first cut of cleaning up libvirt server class. *thanks Ohad Levy*
*   minor cleanups. *thanks Ohad Levy*
*   fixes libvirt wrong state check. *thanks Ohad Levy*
*   libvirt - avoids exception if a uuid is not found. *thanks Ohad Levy*
*   libvirt: servers return nil, not an empty array... *thanks Ohad Levy*
*   Added basic tests to Ovirt compute provider. *thanks Ohad Levy*
*   Added check if Fog.mock! should be used in AWS tests. *thanks Paul Thornthwaite*
*   Nix hardcoded regions: DynamoDB. *thanks Pavel Repin*
*   Nix hardcoded regions: Autoscaling. *thanks Pavel Repin*
*   Nix hardcoded regions: CloudFormation. *thanks Pavel Repin*
*   Nix hardcoded regions: CloudWatch. *thanks Pavel Repin*
*   Nix hardcoded regions: EC2. *thanks Pavel Repin*
*   Nix hardcoded regions: ElastiCache. *thanks Pavel Repin*
*   Nix hardcoded regions: ELB. *thanks Pavel Repin*
*   Nix hardcoded regions: EMR. *thanks Pavel Repin*
*   Nix hardcoded regions: RDS. *thanks Pavel Repin*
*   Nix hardcoded regions: SES. *thanks Pavel Repin*
*   Nix hardcoded regions: SimpleDB. *thanks Pavel Repin*
*   Nix hardcoded regions: SNS. *thanks Pavel Repin*
*   Nix hardcoded regions: SQS (us-east-1 is special). *thanks Pavel Repin*
*   Nix hardcoded regions: S3 (us-east-1 is special). *thanks Pavel Repin*
*   Fixing typo "retreive" -> "retrieve". *thanks Pedro Nascimento*
*   Add the ":idempotent => true" property to create_tags to     fix an issue when launching many instance from cluster_chef. *thanks Peter C. Norton*
*   Ran M-x align-regexp on the hashrockets. *thanks Peter C. Norton*
*   Passing half of rds/instance_tests.rb shindo tests. *thanks Rodrigo Estebanez*
*   making shindo tests for security groups in rds. *thanks Rodrigo Estebanez*
*   Better rds/security_group_test. Mocking rds security_groups. *thanks Rodrigo Estebanez*
*   Support for rds parameter groups mocking. *thanks Rodrigo Estebanez*
*   [aws][auto_scaling] Bug fixed: configurations.get(launch-configuration) always shows the first element. *thanks Rodrigo Estebanez*
*   it doesn't throw an error when the launch configuration doesnt exist. *thanks Rodrigo Estebanez*
*   [aws][auto_scaling]. Support delete_launch_configuration mocking. *thanks Rodrigo Estebanez*
*   Added PrivateIpAddress to the list of valid parameters for instance creation. *thanks Rusty Geldmacher*
*   Add Ecloud version 2.8 as supported. *thanks Shai Rosenfeld*
*   support alias records in the route53 models. *thanks Thom May*
*   Remove unused comment / commented code. *thanks Todd Willey*
*   Fix intial public_url when saving using rackspace_cdn_ssl = true. *thanks Zachary Danger Campbell*
*   added virtual machine support and security group support. *thanks bdorry*
*   merged in 0.11.0 release. *thanks bdorry*
*   merged 1.0.0. *thanks bdorry*
*   remove latest MVP from future possibilities. *thanks geemus*
*   examples should use providers.values. *thanks geemus*
*   fix Fog::Nullable::Boolean to include true/false. *thanks geemus*
*   update fog.io copyright year. *thanks geemus*
*   use path style access for https public_urls that include . to avoid certificate issues     closes #743. *thanks geemus*
*   fix AWS get_object_http(s)_url methods to properly use subdomain vs path urls as appropriate     closes #611. *thanks geemus*
*   loosen multi-json dependency     closes #757. *thanks geemus*
*   remove examples as they are not that helpful or well supported. *thanks geemus*
*   bump excon dep     closes #799. *thanks geemus*
*   bump excon dep. *thanks geemus*
*   strip ARNs - AWS is sensitive to leading and trailing whitespace/cr/lf. *thanks hedgehog*
*   allow for bundler+rbenv best practice. *thanks hedgehog*
*   Rackspace create_image request - pass all options. *thanks kbockmanrs*
*   Add Blue Box location support. *thanks leehuffman*
*   Update location UUID. *thanks leehuffman*
*   Add passing tests. *thanks leehuffman*
*   Fix location_id typo. *thanks leehuffman*
*   Add Blue Box location support. *thanks leehuffman*
*   Update location UUID. *thanks leehuffman*
*   Add passing tests. *thanks leehuffman*
*   Fix location_id typo. *thanks leehuffman*

#### [ninefold|storage]
*   Add copy method to Ninefold::File. *thanks Benjamin Manns*

#### [oVirt]
*   Fixed syntax error in ovirt parser. *thanks Amos Benari*
*   added option to block on start.     Start action will block instead of fail. It can be useful in case of     start after stop or create. *thanks Amos Benari*
*   added support for update vm on ovirt. *thanks Amos Benari*
*   Added VM and Template network-interfaces crud. *thanks Amos Benari*

#### [ovirt|compute]
*   #instance_variables returns Symbols in 1.9.2+. *thanks Dan Peterson*

#### [rackspace/compute]
*   Add 30GB (30720) compute size. *thanks Phil Kates*

#### [rackspace|storage]
*   Add copy_object request. *thanks Benjamin Manns*
*   Add copy method to Rackspace::File. *thanks Benjamin Manns*

#### [slicehost]
*   add deprecation warnings. *thanks geemus*

#### [storage]
*   fixes for deprecated implicit block usage to excon requests. *thanks geemus*
*   update get_object requests to use excon response_blocks. *thanks geemus*

#### [storage|test]
*   Run storage tests on a file in a subdirectory. *thanks Benjamin Manns*

#### [storage|tests]
*   Add copy method to storage tests. *thanks Benjamin Manns*
*   Check that the copied file body matches the original file. *thanks Benjamin Manns*

#### [vcloud]
*   mark mock tests pending. *thanks geemus*

#### [vcloud|compute]
*   rather mock Fog::Vcloud::Connection as this is the right place to mock things. *thanks Peter Meier*
*   improve models + additional tests. *thanks Peter Meier*
*   add API version 1.5 compability. *thanks Peter Meier*

#### [vmfusion|compute]
*   Sync fission v0.4.0 plus more. *thanks Cody Herriges*

#### [voxel]
*   update ssl_verify_peer = false setting. *thanks geemus*

#### [vsphere]
*   add to test skip list when lacking credentials. *thanks geemus*

#### [zerigo|dns]
*   Fixed an issue with updating a record since the response body is an empty string, not nil. *thanks Kevin Menard*
*   Fixed the parser.  TTL and priority values can be nil and should not be coerced into integers in that case. *thanks Kevin Menard*


## 1.1.2 12/18/2011
*Hash* c1873e37e76af83e9de3f3308f3baa0664dd8dc2

Statistic     | Value
------------- | --------:
Collaborators | 20
Downloads     | 351821
Forks         | 332
Open Issues   | 21
Watchers      | 1731

**MVP!** Stepan G. Fedorov

#### [Brightbox]
*   Fix zone_id/flavour_id getter/setter for Server. *thanks Hemant Kumar*
*   Add zone/server_type attribute for Server. *thanks Hemant Kumar*
*   Add username to Image. *thanks Hemant Kumar*
*   Add request for remove_firewall_policy. *thanks Hemant Kumar*
*   Add model method for remove. *thanks Hemant Kumar*
*   Change logic of fetching zone and flavour_id. *thanks Hemant Kumar*
*   Remove name as mandatory parameter for creating server group. *thanks Hemant Kumar*
*   Add created_at attribute for server_group,policy and firewall rule. *thanks Hemant Kumar*
*   Updated Image format tests for username. *thanks Paul Thornthwaite*
*   Updated ServerGroup format for created_at time. *thanks Paul Thornthwaite*

#### [aws|autoscaling]
*   allow sa-east-1 region in mocks. *thanks Nick Osborn*

#### [aws|compute]
*   fix security_group format for mock tests. *thanks geemus*

#### [aws|dns]
*   fix capitilization for records#all options. *thanks geemus*

#### [aws|elb]
*   update SSL certificates on listeners. :christmas_tree:. *thanks Dylan Egan*

#### [aws|storage]
*   Support ACL on copy_object. :v:. *thanks Dylan Egan*

#### [brightbox]
*   Adding *_server actions to ServerGroup model. *thanks Caius Durling*
*   Pass along server_groups when creating a server. *thanks Caius Durling*
*   Make update_cloud_ip request work. *thanks Caius Durling*
*   Firewall models. *thanks Paul Thornthwaite*
*   Added missing requirement and request arg. *thanks Paul Thornthwaite*
*   Corrected deprecated argument. *thanks Paul Thornthwaite*
*   Dynamically select testing image. *thanks Paul Thornthwaite*
*   Helper to get a test server ready. *thanks Paul Thornthwaite*
*   Revised tests structure. *thanks Paul Thornthwaite*
*   Test and fix for API client secret reset. *thanks Paul Thornthwaite*
*   Test update of reverse DNS for CIP. *thanks Paul Thornthwaite*
*   Updated default Ubuntu image. *thanks Paul Thornthwaite*
*   Make Cloud IP model's map nicer to use. *thanks Paul Thornthwaite*
*   Correctly get Server's IP addresses as strings. *thanks Paul Thornthwaite*
*   ServerGroup association to Servers. *thanks Paul Thornthwaite*
*   Replace duplicate remove with move test. *thanks Paul Thornthwaite*
*   Load balancer request tests expanded. *thanks Paul Thornthwaite*
*   Request test for snapshotting a server. *thanks Paul Thornthwaite*
*   fix mock tests. *thanks geemus*

#### [clodo]
*   : Added missing field. *thanks NomadRain*
*   Some cleanup before pool request. *thanks NomadRain*
*   add fake credentials for mock tests. *thanks geemus*

#### [clodo|compute]
*   Bug fixes. *thanks NomadRain*
*   I don't know what is ignore_awful_caching, so i removed it. *thanks Stepan G Fedorov*
*   server.ssh with password. Not only with key. *thanks Stepan G Fedorov*
*   Fix Mocks. *thanks Stepan G Fedorov*
*   Enable get_image_details. *thanks Stepan G Fedorov*
*   Actualize Mocks. *thanks Stepan G. Fedorov*
*   Enable :get_image_details. *thanks Stepan G. Fedorov*
*   Add tests. *thanks Stepan G. Fedorov*
*   Remove ddosprotect field from Mock. *thanks Stepan G. Fedorov*
*   Add ip-address management. *thanks Stepan G. Fedorov*
*   Rename moveip to move_ip_address. *thanks Stepan G. Fedorov*
*   Enable ip-management. *thanks Stepan G. Fedorov*
*   Fix delete_server mock. *thanks Stepan G. Fedorov*
*   Fix move_ip_address behaviour. *thanks Stepan G. Fedorov*
*   Add ip-address management. *thanks Stepan G. Fedorov*
*   Rename moveip to move_ip_address. *thanks Stepan G. Fedorov*
*   Enable ip-management. *thanks Stepan G. Fedorov*
*   Fix delete_server mock. *thanks Stepan G. Fedorov*
*   Fix move_ip_address behaviour. *thanks Stepan G. Fedorov*
*   Added missing field (server.type). *thanks Обоев Рулон ибн Хаттаб*

#### [core]
*   Cast Fog.wait_for interval to float. *thanks Aaron Suggs*
*   fix exceptions from nil credential value. *thanks Blake Gentry*
*   ``@credential`` should always be a symbol. *thanks Hunter Haugen*

#### [docs]
*   note in title that multiple keys is an EC2 thing. *thanks geemus*

#### [glesys|compute]
*   fixed tests due to changes in the api. *thanks Anton Lindström*
*   fix test formats and whitespaces. *thanks Anton Lindström*

#### [misc]
*   parse SQS timestamps as milliseconds. *thanks Andrew Bruce*
*   Allow use of sa-east-1 in the ec2 mock as well. *thanks Andy Delcambre*
*   Enabled tests for setting S3 ACL by id and uri on buckets and objects when mocking. *thanks Arvid Andersson*
*   Added acl_to_hash helper method to Fog::Storage::AWS. *thanks Arvid Andersson*
*   Ensuring that get_object_acl and get_bucket_acl mock methods returns a hash representation of the ACL. *thanks Arvid Andersson*
*   Created Rackspace LB models folder. *thanks Brian Hartsock*
*   This patch adds the ability to specify security groups by security group id, rather than group name.  This is a required feature to use security groups within a VPC. *thanks Eric Stonfer*
*   indentation change. *thanks Eric Stonfer*
*   Add the ability to return the security group ID when requesting a SecurityGroupData object. *thanks Eric Stonfer*
*   fix tests to accomodate the new SecurityGroupId. *thanks Eric Stonfer*
*   Revert "fix tests to accomodate the new SecurityGroupId". *thanks Eric Stonfer*
*   fix tests to accomodate the addition of security_group_id. *thanks Eric Stonfer*
*   indentation fix. *thanks Eric Stonfer*
*   indentation fix. *thanks Eric Stonfer*
*   [Brightbox]Add remove_firewall_policy to computer.rb. *thanks Hemant Kumar*
*   [Brightbox]Protocol is no longer required parameter for firewall. *thanks Hemant Kumar*
*   Add implementation of DescribeInstanceStatus. *thanks JD Huntington & Jason Hansen*
*   fixed type-o in rdoc on Fog::DNS:DNSMadeEasy. *thanks John Dyer*
*   add query options to Fog::Storage::AWS#get_object_https_url. *thanks Mateusz Juraszek*
*   add options hash to Fog::Storage::AWS::File#url and Fog::Storage::AWS::Files#get_https_url which use get_object_https_url method. *thanks Mateusz Juraszek*
*   add query param to get_object_http_url for consistency. *thanks Mateusz Juraszek*
*   Fix regression in Rakefile introduced in 70e7ea13. *thanks Michael Brodhead*
*   add são paulo/brasil region. *thanks Raphael Costa*
*   mock create_db_instance. *thanks Rodrigo Estebanez*
*   mocking describe_db_instance. Fix hash structure in create_db_instance. *thanks Rodrigo Estebanez*
*   mocking delete_db_instance. *thanks Rodrigo Estebanez*
*   mocking wait_for through describe_db_instances. *thanks Rodrigo Estebanez*
*   mocking modify_db_instance and reboot_db_instance. *thanks Rodrigo Estebanez*
*   raise exception instead of excon response. *thanks Rodrigo Estebanez*
*   Fixing bug: It always showed the first instance when using get. *thanks Rodrigo Estebanez*
*   Fixes for issues 616 and 617. *thanks Sergio Rubio*
*   * remove unnecessary debugging. *thanks Sergio Rubio*
*   * Add missing recognized :libvirt_ip_command. *thanks Sergio Rubio*
*   * Add server_name environment variable to ip_command. *thanks Sergio Rubio*
*   * implement :destroy_volumes in Server.destroy (libvirt provider). *thanks Sergio Rubio*
*   Add documentation for using multiple ssh keys on AWS. *thanks Sven Pfleiderer*
*   Update bootstrap description. *thanks Sven Pfleiderer*
*   Escape underscore charakters. *thanks Sven Pfleiderer*
*   implement STS support. *thanks Thom May*
*   Allow use of session tokens in AWS Compute. *thanks Thom May*
*   handle session tokens for SQS and SimpleDB. *thanks Thom May*
*   Split [AWS|STS] tests into separate files per #609. *thanks Thom May*
*   Bug fix, metric_statistic#save would always fail. *thanks bmiller*
*   bump excon dep. *thanks geemus*
*   bump excon dep. *thanks geemus*
*   Fixing Rackspace's lack of integer-as-string support as per https://github.com/fog/fog/pull/657#issuecomment-3145337. *thanks jimworm*
*   add current set of elasticache endpoints. *thanks lostboy*
*   added sa-east-1 region. *thanks thattommyhall*
*   Add clodo support. *thanks Обоев Рулон ибн Хаттаб*
*   Enable clodo support. *thanks Обоев Рулон ибн Хаттаб*

#### [rackspace|dns]
*   error state callbacks now return an error. *thanks Brian Hartsock*
*   fixed broken test. *thanks Brian Hartsock*
*   should recognize rackspace_dns_endpoint argument. *thanks geemus*
*   record should pass priority. *thanks geemus*
*   mark tests for models pending in mocked mode. *thanks geemus*

#### [rackspace|lb]
*   Fixed bug #644 with HTTP health monitors. *thanks Brian Hartsock*
*   fix for #650 - Connection logging now loads appropriately. *thanks Brian Hartsock*
*   added error page requests. *thanks Brian Hartsock*
*   Added error pages to the model. *thanks Brian Hartsock*
*   Added list parameter for nodeddress. *thanks Brian Hartsock*
*   fixed broken test; cleaned up some tests. *thanks Brian Hartsock*

#### [rackspace|load balancers]
*   fixed broken tests. *thanks Brian Hartsock*

#### [rackspace|loadbalancers]
*   Fixed bug in deleting multiple nodes. *thanks Brian Hartsock*

#### [slicehost|compute]
*   update image id in tests. *thanks geemus*

#### [storm_on_demand]
*   fixes for formats in tests. *thanks geemus*

#### [tests | clodo]
*   Added ip-management tests. *thanks Stepan G. Fedorov*
*   Added ip-management tests. *thanks Stepan G. Fedorov*

#### [tests | clodo ]
*   ddosprotect field must not exist. *thanks Stepan G. Fedorov*

#### [tests | clodo | compute]
*   Add most tests. *thanks Stepan G Fedorov*
*   Add image tests. *thanks Stepan G Fedorov*

#### [tests | clodo | compute ]
*   create_server - First try. *thanks Stepan G Fedorov*

#### [vcloud]
*   mark tests pending in mocked mode. *thanks geemus*

#### [vcloud|compute]
*   introduce organizations. *thanks Peter Meier*
*   make networks working also in organizations. *thanks Peter Meier*
*   remove server from organizations as they are within vApps of vDC. *thanks Peter Meier*
*   add catalogs to an organization. *thanks Peter Meier*
*   a vdc does not have a tasklist. *thanks Peter Meier*
*   introduce vapps. *thanks Peter Meier*
*   More work on getting server in a useable shape. *thanks Peter Meier*
*   fix network to the minimum. *thanks Peter Meier*
*   a vapp might not have any childrens attached. *thanks Peter Meier*
*   improve models add tests. *thanks Peter Meier*
*   improve disk info access. *thanks Peter Meier*
*   improve network. *thanks Peter Meier*
*   introduce link on a network to parent network. *thanks Peter Meier*
*   fix an issue if this is not parsed as an array. *thanks Peter Meier*
*   stopgap fix for test data files. *thanks geemus*
*   properly namespace vcloud test to prevent breaking others. *thanks geemus*

#### [vsphere]
*   (#10644) Add servers filter to improve clone performance. *thanks Jeff McCune*
*   fix whitespace issue in yaml for mocks. *thanks geemus*


## 1.1.1 11/11/2011
*Hash* a468aa9a3445aae4f496b1a51e26572b8379c3da

Statistic     | Value
------------- | --------:
Collaborators | 19
Downloads     | 300403
Forks         | 300
Open Issues   | 14
Watchers      | 1667

#### [core]
*   loosen net-ssh dependency to avoid chef conflict. *thanks geemus*

#### [misc]
*   1.1.0 changelog. *thanks geemus*


## 1.1.0 11/11/2011
*Hash* b706c7ed66c2e760fdd6222e38c68768575483b2

Statistic     | Value
------------- | --------:
Collaborators | 19
Downloads     | 300383
Forks         | 300
Open Issues   | 16
Watchers      | 1667

**MVP!** Michael Zeng

#### [Compute|Libvirt]
*   Take into account a query string can be empty, different on some rubies it gives nil, on some empty string. *thanks Patrick Debois*

#### [OpenStack|compute]
*   fix v2.0 auth endpoints. *thanks Todd Willey*
*   default metadata to empy hash. *thanks Todd Willey*
*   add zone awareness. *thanks Todd Willey*

#### [aws]
*   add us-west-2 region. *thanks geemus*

#### [aws|cloud_watch]
*   mark tests pending when mocked. *thanks geemus*

#### [aws|cloudwatch]
*   Add support for put-metric-alarm call. *thanks Jens Braeuer*
*   Remove duplicate RequestId from response. *thanks Jens Braeuer*
*   Add mocked implementation of put_metric_alarm. *thanks Jens Braeuer*
*   Fix whitespace. *thanks Jens Braeuer*
*   Fix merge error. *thanks Jens Braeuer*
*   Add mocked version of put_metric_alarm. *thanks Jens Braeuer*

#### [aws|compute]
*   Mock modify_image_attribute add/remove users. *thanks Dan Peterson*
*   Allow mock tagging to work across accounts. *thanks Dan Peterson*
*   Fix new instance eventual consistency for the non-filtered case. *thanks Dan Peterson*
*   Update security group operations. *thanks Dan Peterson*
*   Test for more invalid security group request input when mocking. *thanks Dan Peterson*
*   Fix a bug in delete_tags, but come up against a bug in AWS where tags aren't deleted if the resource still exists. *thanks Dylan Egan*
*   tags are reset when reloading. #570. *thanks Dylan Egan*
*   fixed sopt_instance_request reply parsing when the original     request contained a device mapping. *thanks MaF*
*   wait_for reload then add server tags. *thanks geemus*
*   spot request fixes. *thanks geemus*
*   tweaks for spot request bootstrap. *thanks geemus*
*   save tags for spot_requests#bootstrap. *thanks geemus*
*   update ami for windows. *thanks geemus*

#### [aws|elb]
*   Missed a change as part of #545. *thanks Dan Peterson*
*   use a set union to register new instances. *thanks Dylan Egan*
*   return only the instance IDs on describe. Use only available availability zones. :v:. *thanks Dylan Egan*
*   attribute aliases for CanonicalHostedZoneName(ID). :v:. *thanks Dylan Egan*
*   eventually consistent, like me getting a haircut. :v:. *thanks Dylan Egan*

#### [aws|emr]
*   mark tests pending when mocked. *thanks geemus*

#### [aws|iam]
*   slight cleanup and test with a certificate chain. :cake:. *thanks Dylan Egan*

#### [aws|mock]
*   Dig into mock data instead of instantiating new service objects. *thanks Dan Peterson*

#### [aws|storage]
*   ensure path isn't empty when specifying endpoint. *thanks geemus*

#### [brightbox]
*   Fixed incorrect call to reset_ftp_password. *thanks Paul Thornthwaite*

#### [brightbox|compute]
*   format fixes for tests. *thanks geemus*

#### [core]
*   treat boolean values as a boolean. *thanks Peter Meier*
*   fix attribute squashing with : in key. *thanks Peter Meier*
*   all services should recognize :connection_options. *thanks geemus*
*   separate loggers for deprecations/warnings. *thanks geemus*
*   avoid duplicates in Fog.providers. *thanks geemus*
*   more useful structure for Fog.providers. *thanks geemus*
*   add newlines to logger messages. *thanks geemus*
*   update stats raketask to point to org. *thanks geemus*
*   toss out nil-value keys when checking required credentials. *thanks geemus*

#### [dns]
*   Made model tests use uniq domain names. *thanks Brian Hartsock*

#### [dnsmadeeasy|dns]
*   Fix Fog::DNS::DNSMadeEasy::Record#save to handle updating a record correctly. *thanks Peter Weldon*

#### [docs]
*   update links to point to http://github.com/fog/fog. *thanks geemus*

#### [dynect|dns]
*   Automatically poll jobs if we get them. Closes #575. *thanks Dan Peterson*

#### [misc]
*   Change response parameter. *thanks Alan Ivey*
*   Missing HEAD method. *thanks Andrew Newman*
*   Missing HEAD method. *thanks Andrew Newman*
*   Putting version back. *thanks Andrew Newman*
*   Reformatting and making consistent with other classes. *thanks Andrew Newman*
*   Missed renam to head_namespace. *thanks Andrew Newman*
*   Reverting version and date in gemspec. *thanks Andrew Newman*
*   Formatting. *thanks Andrew Newman*
*   Removed puts of element name. *thanks Arvid Andersson*
*   Changes to allow EMR control through fog. *thanks Bob Briski*
*   Added EMR functions for AWS. *thanks Bob Briski*
*   Adding tests. *thanks Bob Briski*
*   merge EMR changes with upstream repo. *thanks Bob Briski*
*   (#10055) Search vmFolder inventory vs children. *thanks Carl Caum*
*   Adding a path attribute to the vm_mob_ref hash. *thanks Carl Caum*
*   Cleanup Attributes#merge_attributes. *thanks Hemant Kumar*
*   Update S3 doc example to show current API. *thanks Jason Roelofs*
*   Restructure main website's navigation. *thanks Jason Roelofs*
*   Add CloudFormation UpdateStack call. *thanks Jason Roelofs*
*   Minor whitespace change. *thanks Jens Braeuer*
*   Trailing whitespace cleanup. *thanks Jens Braeuer*
*   Whitespace cleanup. *thanks Jens Braeuer*
*   Fix merge error. *thanks Jens Braeuer*
*   Removed statement about `@geemus` being only member of collaborators list since it's not true anymore. *thanks John Wang*
*   Fixes Fog::AWS::Storage#put_(bucket|object)_acl. *thanks Jonas Pfenniger*
*   Randomize bucket names in tests. *thanks Jonas Pfenniger*
*   Fix AWS S3 bucket and object tests. *thanks Jonas Pfenniger*
*   (#10570) Use nil in-place of missing attributes. *thanks Kelsey Hightower*
*   (#10570) Update `Fog::Compute::Vsphere` tests. *thanks Kelsey Hightower*
*   We use 'Key' for all S3 objects now. *thanks Kevin Menard*
*   Implemented mocks for Zerigo. *thanks Kevin Menard*
*   Updated docs to use newer arg, rather than the old deprecated one. *thanks Kevin Menard*
*   Added the ability to search Zerigo records for a particular zone. *thanks Kevin Menard*
*   Return the only element of the array, not the array itself. *thanks Kevin Menard*
*   Fixed an issue whereby saving an existing record in Zerigo would nil out its value. *thanks Kevin Menard*
*   added DeleteAlarms, DescribeAlarms and PutMetricAlarms. *thanks Michael Zeng*
*   re-adding files. *thanks Michael Zeng*
*   adding describe_alarm_history. *thanks Michael Zeng*
*   adding diable/enable alarm actions. *thanks Michael Zeng*
*   added DescribeAlarmHistory request and parser. *thanks Michael Zeng*
*   fixing describe_alarms and describe_alarms_for_metric requests. *thanks Michael Zeng*
*   cleaned up requesters and parsers. *thanks Michael Zeng*
*   added SetAlarmState. *thanks Michael Zeng*
*   included more response elements, request parameters should now be complete. Included model and collection classes. *thanks Michael Zeng*
*   bug fixes. *thanks Michael Zeng*
*   fixed models and added tests. *thanks Michael Zeng*
*   no need to add rake dep. *thanks Michael Zeng*
*   revert gempspec date change. *thanks Michael Zeng*
*   reverting cloud_watch.rb. *thanks Michael Zeng*
*   reverting cloud_watch.rb. *thanks Michael Zeng*
*   reverting cloud_watch.rb. *thanks Michael Zeng*
*   reverting cloud_watch.rb. *thanks Michael Zeng*
*   reverting cloud_watch.rb. *thanks Michael Zeng*
*   added newline to the end of file. *thanks Michael Zeng*
*   removed all tabs. *thanks Michael Zeng*
*   added alarm_data_tests. *thanks Michael Zeng*
*   spacing change. *thanks Michael Zeng*
*   AWS#hash_to_acl - add support for EmailAddress and URI grantee types. *thanks Nathan Sutton*
*   Test and improve Fog::Storage::AWS.hash_to_acl. *thanks Nathan Sutton*
*   Adding a method to unmock Fog. Addresses issue #594. *thanks Nathan Sutton*
*   Adding documentation for Fog.unmock! and Fog::Mock.reset. *thanks Nathan Sutton*
*   added linode ssh support. *thanks Nicholas Ricketts*
*   added linode ssh support with proper public ip address. *thanks Nicholas Ricketts*
*   cleaned up code to use att_XX methods. *thanks Nicholas Ricketts*
*   clean up public_ip_address code for linode. *thanks Nicholas Ricketts*
*   Seems like rackspace might have changed this. *thanks Nik Wakelin*
*   Sends power parameter in GoGrid's grid_server_power request. *thanks Pablo Baños López*
*   Slicehost uses record-type and zone-id for their API, which messes with Fog internals, so changing these to record_type and zone_id in the parser. *thanks Patrick McKenzie*
*   Did this do anything?. *thanks Patrick McKenzie*
*   Revert "Slicehost uses record-type and zone-id for their API, which messes with Fog internals, so changing these to record_type and zone_id in the parser.". *thanks Patrick McKenzie*
*   Not having the best of days with git.  Revert the reversion of the commit that I really do want to make. *thanks Patrick McKenzie*
*   Slicehost uses record-type and zone-id for their API, which messes with Fog internals, so changing these to record_type and zone_id in the parser. *thanks Patrick McKenzie*
*   Do not touch .gitignore. *thanks Patrick McKenzie*
*   Fixing Slicehost DNS so that a) tests pass b) token names map to what Fog expects -- record_type not record-type, value not data, etc c) creation of new DNS records possible. *thanks Patrick McKenzie*
*   1)  Fix so that getting a single record actually works.  2)  zone.records currently returns all records in account, not just records for that zone.  Add failing test (temporarily, assumes test account has existing zones for this to actually fail) + fix.  3)  Add in data alias for record.value, just in case someone needs it, as Slicehost calls this data. *thanks Patrick McKenzie*
*   Allow updates of DNS records.  Updates on zones not supported yet. *thanks Patrick McKenzie*
*   Fixing parsing of zone.records.get(id) so that it parses a single record properly rather than attempting to parse a list of records improperly.  Fixing tests to match this (expected) behavior rather than work-around the broken way. *thanks Patrick McKenzie*
*   Getting it so zone.records works as expected (loads all records, for that zone only). *thanks Patrick McKenzie*
*   simplification. *thanks Peter Meier*
*   Optimize vSphere convert_vm_mob_ref_to_attr_hash. *thanks Rich Lane*
*   Compact the way options are mapped to request. *thanks Todd Willey*
*   Allow setting userdata as plain ascii or b64. *thanks Todd Willey*
*   bump excon dep. *thanks geemus*
*   [rackspace][dns] fixes for job request format. *thanks geemus*
*   bump net-ssh dependency. *thanks geemus*
*   tshirt offer should be implicit, rather than explicit. *thanks geemus*
*   add region option to aws sns service recognizes method. *thanks lostboy*
*   add capabilities support to cloudformation createstack request. *thanks lostboy*

#### [ninefold|storage]
*   omit signature in stringtosign. *thanks geemus*
*   check objectid for existence. *thanks geemus*
*   allow overwriting files for consistency. *thanks geemus*

#### [rackspace|dns]
*   Fixed request tests that need unique domain name. *thanks Brian Hartsock*
*   Adapted to changes in callback mechanism. *thanks Brian Hartsock*

#### [rackspace|load_balancers]
*   made lb endpoint configurable. *thanks Brian Hartsock*

#### [release]
*   omit Patrick Debois from future MVP status. *thanks geemus*

#### [vsphere|compute]
*   test fixes. *thanks geemus*


## 1.0.0 09/29/2011
*Hash* a81be08ef2473af91f16f4926e5b3dfa962a34ae

Statistic     | Value
------------- | --------:
Collaborators | 16
Downloads     | 245745
Forks         | 260
Open Issues   | 13
Watchers      | 1521

**MVP!** Patrick Debois

#### [Libvirt]
*   if transport is empty, ssh can't be enabled. *thanks Patrick Debois*
*   Enable to pass an libvirt_ip_command for looking up the mac -> ip_address . Using eval to allow for passing of mac address in ip_command. *thanks Patrick Debois*
*   corrected typo for appending string output to IO.popen. *thanks Patrick Debois*
*   initialize the ip_address as an empty string. *thanks Patrick Debois*
*   more specific error if the ip_command results in string that has no ip-address format. *thanks Patrick Debois*
*   Remove the newlines after running the local ip_command. *thanks Patrick Debois*
*   rename xml_desc to xml as an attribute and hide all non_dynamic attributes from fog console. *thanks Patrick Debois*
*   added blocked state and corrected crashed to shutoff state. *thanks Patrick Debois*
*   renamed 'raw' connection to raw in the Fog Connection. *thanks Patrick Debois*

#### [Libvirt|Compute]
*   renamed all disk_ params for server creation to volume_ to make it consistent with the object type volume. *thanks Patrick Debois*

#### [aws]
*   remove base64 require (duplicates require in fog/core). *thanks geemus*

#### [aws/sqs]
*   Adding SQS mocking support. *thanks Istvan Hoka*

#### [aws|acs]
*   Create ACS security_group model and collection. *thanks Aaron Suggs*
*   Improve security group tests. *thanks Aaron Suggs*
*   Adds ACS#delete_cache_security_group. *thanks Benton Roberts*
*   Added security group methods. *thanks Benton Roberts*
*   Update CacheSecurityGroup API to public beta 2011-07-15. *thanks Benton Roberts*

#### [aws|cloudwatch]
*   Fix whitespace. *thanks Jens Braeuer*

#### [aws|compute]
*   add snapshot method to volume model. *thanks Andrei Serdeliuc*
*   Correct path. *thanks Dylan Egan*
*   raise an ArgumentError if image_id is nil, otherwise an ugly InternalError is returned from AWS. *thanks Dylan Egan*
*   wait for ready before testing tags. *thanks geemus*
*   fixes for mocks tests. *thanks geemus*
*   fix formatting for mock security groups. *thanks geemus*

#### [aws|dns]
*   fix parser path. *thanks geemus*

#### [aws|elasticache]
*   refactor acs->elasticache. *thanks Benton Roberts*
*   refactor for whitespace / readability. *thanks Benton Roberts*
*   fix typo in Elasticache Security Group tests. *thanks Benton Roberts*
*   rename test file for shindo. *thanks Benton Roberts*
*   create and describe cache clusters. *thanks Benton Roberts*
*   delete cache clusters. *thanks Benton Roberts*
*   add Cache Cluster model and collection. *thanks Benton Roberts*
*   Fix bug in AWS::Elasticache::Cluster.get. *thanks Benton Roberts*
*   randomize cache cluster IDs in testing. *thanks Benton Roberts*
*   return nil on CacheClusterNotFound. *thanks Benton Roberts*
*   use Formatador for testing output. *thanks Benton Roberts*
*   move ClusterNotFound rescue code into Elasticache service definition. *thanks Benton Roberts*
*   change method profile for create_cache_cluster, delete_cache_cluster, and describe_cache_clusters. *thanks Benton Roberts*
*   change parameters for describe_cache_security_groups to ruby-friendly values. *thanks Benton Roberts*
*   remove port attribute from cluster model. *thanks Benton Roberts*
*   fix Elasticahce::Cluster.security_groups attribute. *thanks Benton Roberts*
*   implement modify_cache_cluster request. *thanks Benton Roberts*
*   cluster port number cannot be modified. *thanks Benton Roberts*
*   add cache node info to describe_cache_clusters. *thanks Benton Roberts*
*   add InvalidInstace error class. *thanks Benton Roberts*
*   remove optional parameters from Elasticache::Cluster. *thanks Benton Roberts*
*   show cluster node details by default in model. *thanks Benton Roberts*
*   add test for removing a cache node. *thanks Benton Roberts*
*   add pending_values to modified nodes. *thanks Benton Roberts*
*   implement RebootCacheCluster. *thanks Benton Roberts*
*   implement DescribeEvents. *thanks Benton Roberts*
*   implement basic parameter group requests. *thanks Benton Roberts*
*   implement describe_engine_default_parameters request. *thanks Benton Roberts*
*   implement Elasticache::ParameterGroup model and collection. *thanks Benton Roberts*
*   implement modify_cache_parameter_group request. *thanks Benton Roberts*
*   implement reset_cache_parameter_group request. *thanks Benton Roberts*
*   implement describe_cache_groups request. *thanks Benton Roberts*
*   test fix: change DESCRIBE_SECURITY_GROUPS helper format. *thanks Benton Roberts*
*   delete outdated test file. *thanks Benton Roberts*

#### [aws|elb]
*   Raise a custom exception for Throttling. *thanks Dylan Egan*
*   wait_for server to be ready? before register. *thanks geemus*

#### [aws|iam]
*   implement correct path behaviour in mocking. *thanks Dylan Egan*

#### [aws|simpledb]
*   fix tests to use proper accessor. *thanks geemus*

#### [aws|storage]
*   fix acl mocking. *thanks geemus*

#### [bluebox|compute]
*   Fixed instance state. *thanks Lee Huffman*
*   Create and destroy images. *thanks Lee Huffman*
*   Fix for setting hostname on server save. *thanks Lee Huffman*
*   Expect correct status code for template create. *thanks Lee Huffman*

#### [cdn|aws]
*   move aws cdn to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [cdn|rackspace]
*   move rackspace cdn to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute]
*   fix service calls I missed in recent rearrange. *thanks geemus*

#### [compute|aws]
*   - Change modify_instance_attribute name to match EC2 API method, and actually make it do something. *thanks Caleb Tennis*
*   Include ids of things we're modifying in requests. *thanks Dan Peterson*
*   Fix create_volume mock when creating from a snapshot. *thanks Dan Peterson*
*   Make get_bucket_location mock return LocationConstraint as API doc describes. *thanks Dan Peterson*
*   Fix associate_address mock to detach/revert previous addresses properly. *thanks Dan Peterson*
*   Don't warn in mock describe_snapshots if RestorableBy is 'self'. *thanks Dan Peterson*
*   When mocking, instances don't show up right away. *thanks Dan Peterson*
*   Suffix with _tests.rb. *thanks Dylan Egan*
*   IpPermissionsEgress is returned from AWS. *thanks Dylan Egan*
*   Simple test to verify revoke_group_and_owner behaviour. *thanks Dylan Egan*
*   Apparently passing a nil value works against live AWS. Only use SourceSecurityGroupOwnerId in mocks if supplied. *thanks Dylan Egan*
*   Since this is really proving the use of nil, let's just not pretend there's a value for owner_id. *thanks Dylan Egan*
*   sometimes the platform string is returned. *thanks Dylan Egan*
*   enable tests for mocked tags. *thanks Dylan Egan*
*   Fix NameError. *thanks Jens Braeuer*
*   Fix bug in tag mocking preventing servers from being updated with new tags. *thanks Matt Griffin*
*   Add mocking for describe_tags. *thanks Matt Griffin*
*   move aws compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|bluebox]
*   move bluebox compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|brightbox]
*   Allow persistent option to be passed to Brightbox::Compute. *thanks Caius Durling*
*   Updated test for new behaviour. *thanks Paul Thornthwaite*
*   Picking up more attributes from Account. *thanks Paul Thornthwaite*
*   No need to hardcode a server type. *thanks Paul Thornthwaite*
*   Updated and reordered model attributes. *thanks Paul Thornthwaite*
*   Updates to tests. *thanks Paul Thornthwaite*
*   Added resave warning to a few Brightbox models. *thanks Paul Thornthwaite*
*   Requests for server group management. *thanks Paul Thornthwaite*
*   Merge in test updates and server groups. *thanks Paul Thornthwaite*
*   Corrected require missed in update. *thanks Paul Thornthwaite*
*   Reset times to the correct type so not string attributes. *thanks Paul Thornthwaite*
*   Updated Format test to remove gone fields. *thanks Paul Thornthwaite*
*   Fixed typo in connection options. *thanks Paul Thornthwaite*
*   Added missing requests. *thanks Paul Thornthwaite*
*   Added requests for firewall management. *thanks Paul Thornthwaite*
*   Added ServerGroup model and collections. *thanks Paul Thornthwaite*
*   Passing options to server group update. *thanks Paul Thornthwaite*
*   Fixed server_groups.get. *thanks Paul Thornthwaite*
*   move brightbox compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|ecloud]
*   move ecloud compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|glesys]
*   added glesys as provider. *thanks Anton Lindstrom*
*   added tests. *thanks Anton Lindström*
*   fixed logical error for default values. *thanks Anton Lindström*
*   fixed an invalid character. *thanks Anton Lindström*
*   consistency/cleanup. *thanks geemus*
*   fix format for start vs stop. *thanks geemus*
*   rearrange to match current naming conventions. *thanks geemus*

#### [compute|go_grid]
*   move go_grid compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|libvirt]
*   merge jedi4ever/libvirt. *thanks geemus*
*   move libvirt compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|linode]
*   move linode compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|bare_metal_cloud]
*   move bare_metal_cloud compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|ninefold]
*   move ninefold compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|rackspace]
*   move rackspace compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|slicehost]
*   move slicehost compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|storm_on_demand]
*   move storm_on_demand compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|vcloud]
*   move vcloud compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|virtual_box]
*   move virtual_box compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [compute|voxel]
*   move voxel compute to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [core]
*   Allow FOG_CREDENTIAL env variable for config. *thanks Aaron Suggs*
*   add collection#destroy(identity). *thanks geemus*
*   move openssl to more central location. *thanks geemus*
*   first steps toward seperately requirable bits. *thanks geemus*
*   move providers to lib/fog/. *thanks geemus*
*   work toward separate requires. *thanks geemus*
*   prototype logger. *thanks geemus*
*   add get/set methods for logger channels. *thanks geemus*
*   use logger throughout for warnings. *thanks geemus*
*   coerce service credentials. *thanks geemus*
*   delete nil valued keys from config. *thanks geemus*
*   pass connection_options through service init. *thanks geemus*
*   don't rely on bin stuff for service init in tests. *thanks geemus*
*   dedup services listings. *thanks geemus*
*   more convenient accessors. *thanks geemus*
*   fixing more paths after rearrange. *thanks geemus*
*   add credentials setter. *thanks geemus*
*   make sure credentials tests properly reset after completion. *thanks geemus*
*   bump excon dep. *thanks geemus*
*   properly fix credentials tests. *thanks geemus*
*   skip vmfusion in rake nuke. *thanks geemus*
*   bump excon. *thanks geemus*
*   kill dns stuff in nuke as well. *thanks geemus*

#### [dns]
*   update dns constructor to match recent file moves. *thanks geemus*

#### [dns|aws]
*   move aws dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|bluebox]
*   move bluebox dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|dnsimple]
*   move dnsimple dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|dnsmadeeasy]
*   move dnsmadeeasy dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|dynect]
*   move dynect dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|linode]
*   move linode dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|rackspace]
*   initial commit. *thanks Brian Hartsock*
*   list_domains request. *thanks Brian Hartsock*
*   added attributes to list_domains; refactored rackspace errors to be shared with load balancers. *thanks Brian Hartsock*
*   move rackspace dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|slicehost]
*   move slicehost dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [dns|zerigo]
*   move zerigo dns to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [doc]
*   Added blogpost about libvirt into fog to the press page. *thanks Patrick Debois*
*   corrected the link to the actual blogpost instead of the github markdown page :). *thanks Patrick Debois*

#### [docs]
*   add note about ec2 default username. *thanks geemus*

#### [dynect|dns]
*   use a string for now. #362 is open for accepting symbols in mocks. *thanks Dylan Egan*
*   return the zone name. *thanks Dylan Egan*
*   accidentally hardcoded the record type in the mocked data. *thanks Dylan Egan*
*   support ANY record results. *thanks Dylan Egan*
*   Don't use address as different records have different arguments, just send rdata. Remove value. Add CNAME test. *thanks Dylan Egan*
*   find, not first. *thanks Dylan Egan*
*   always ensure it's an integer. *thanks Dylan Egan*
*   retry if auth_token was previously set and error message includes possible login expiration. *thanks Dylan Egan*
*   support reauth for inactivity logout too. *thanks Dylan Egan*

#### [glesys|compute]
*   fixes to play nice with mock tests. *thanks geemus*
*   skip flavor tests. *thanks geemus*

#### [gleysys]
*   fixes for mocked test setup. *thanks geemus*

#### [libvirt]
*   Added option libvirt_ip_command to the credentials error page. *thanks Patrick Debois*
*   Corrected template variable from interface_nat_network to network_nat_network. *thanks Patrick Debois*

#### [linode|compute]
*   update format for plans. *thanks geemus*

#### [load balancer|rackspace]
*   fixed some minor bugs i noticed in the tests. *thanks Brian Hartsock*

#### [misc]
*   Fixed a couple of errors in the examples. *thanks Bobby Wilson*
*   Implement fog support for the Openstack Compute API v1.1. Includes     support for legacy v1.0 style auth and v2.0 keystone auth. *thanks Dan Prince*
*   Add create_image to server model. *thanks Dan Prince*
*   Add support for non-strict validations, and nullable arrays/hashes. *thanks Dan Prince*
*   Additions and updates to the OpenStack API tests. *thanks Dan Prince*
*   Beginning of Dynect::DNS mocking support. *thanks Dylan Egan*
*   get_record, single. *thanks Dylan Egan*
*   Tidy up a bit. *thanks Dylan Egan*
*   Support freeze and thaw. *thanks Dylan Egan*
*   sleep for 3 seconds when running against Dynect because otherwise there is an operation still in progress. *thanks Dylan Egan*
*   raise a NotFound if not found. *thanks Dylan Egan*
*   Fog::DNS::Dynect, not Fog::Dynect::DNS. *thanks Dylan Egan*
*   InstanceId should have index according to AWS Docs. *thanks E.J. Finneran*
*   fix indenting to get markdown to recognise the code block properly. *thanks Glenn Tweedie*
*   Better URL escaping for Rackspace Cloud Files. *thanks H. Wade Minter*
*   Tweak to escape the Cloud Files filename before passing to public_url. *thanks H. Wade Minter*
*   Put escaping logic into the collection get_url call. *thanks H. Wade Minter*
*   (#9241) Add skeleton VMware vSphere platform support. *thanks Jeff McCune*
*   (#9241) Add SSL verification. *thanks Jeff McCune*
*   (#9241) Add current_time request. *thanks Jeff McCune*
*   (#9241) Add model for Fog::Compute[:vsphere].servers. *thanks Jeff McCune*
*   (#9241) Add test skeleton framework. *thanks Jeff McCune*
*   (#9241) Add ability to find VMs by UUID. *thanks Jeff McCune*
*   (#9421) Add start, stop, reboot server model methods. *thanks Jeff McCune*
*   (#9241) Add destroy API request and model action. *thanks Jeff McCune*
*   (#9241) Add find_template_by_instance_uuid request. *thanks Jeff McCune*
*   (#9241) Add vm_clone API request. *thanks Jeff McCune*
*   (#9241) Don't fail when trying to model a cloning VM. *thanks Jeff McCune*
*   (#9241) Make the reload action of the server models work. *thanks Jeff McCune*
*   (#9124) Add ability to reload the model of a cloning VM. *thanks Jeff McCune*
*   Refactor requests to return simple hashes and add unit tests. *thanks Jeff McCune*
*   Add vsphere_server connection attribute. *thanks Jeff McCune*
*   Fix vm clone problem when a Guid instance is passed as the instance_uuid. *thanks Jeff McCune*
*   Fix documentation. The resulting hash has no entry "PutScalingPolicyResponse", but a "...Result". *thanks Jens Braeuer*
*   Pass hostname to create_block request if provided. *thanks Lee Huffman*
*   Added Fog::CurrentMachine#ip_address. *thanks Pan Thomakos*
*   First cut at libvirt integration. Lots of features missing, but it proves the point. *thanks Patrick Debois*
*   - Added URI helper to parse libvirt URL's     - exposed Libvirt original connection in Compute object     - exposed URI in Compute object     - added libvirt-ruby gem to the developer Gemspec. *thanks Patrick Debois*
*   - Get all pools now by name or by uuid     - Create pool by providing xml     - Destroy pool. *thanks Patrick Debois*
*   Added ability to create/destroy volumes     You can search for volumes by path,key,name     And list all volumes from a pool. *thanks Patrick Debois*
*   Allow creation of persistent or non persistent volumes. *thanks Patrick Debois*
*   Again major breakthrough. *thanks Patrick Debois*
*   Coming along nicely. *thanks Patrick Debois*
*   - ERB has a problem with a variable called type, it expands it on ruby 1.8 to .class     - If the key or the volume is not found, maybe because the pool has not yet been started, the volumes should return nil. *thanks Patrick Debois*
*   Changed the monitoring command for IP addresses     arpwatch.dat is not the correct place, it should be via syslog, or seperate file. *thanks Patrick Debois*
*   fixing whitespace. *thanks Patrick Debois*
*   removed trailing spaces. *thanks Patrick Debois*
*   indenting the files. *thanks Patrick Debois*
*   check ip-address that returned from the search in the logfile. *thanks Patrick Debois*
*   Added a way to locally retrieve the ipaddress through the ip_command     More checks on correctness of ipaddress     And checks on ssh failures. *thanks Patrick Debois*
*   renamed ipaddress to ip_address     made the .id available and an alias to uuid for server. *thanks Patrick Debois*
*   Added description on the libvirt environment can be initialized and the     requirements for ssh and ipaddress to work. *thanks Patrick Debois*
*   Added a global libvirt provider option ip_command to specify the ip_command     Also more robust handling of connection error when the libvirt connection fails. *thanks Patrick Debois*
*   Remove the idea of template_options, now you specify the param directly     in the create command.     Unit and Size are now calculated. *thanks Patrick Debois*
*   Removed the template_options param. *thanks Patrick Debois*
*   Fixed disk_format_type vs disk_type_format difference     and changed disk_format_type in the template as well. *thanks Patrick Debois*
*   added openauth support *thanks to `@rubiojr.` thanks Patrick Debois*
*   changed return code of state to string instead of symbols to be consistent with aws provider. *thanks Patrick Debois*
*   - Added concept of nodes (host of domains = node)     - Renamed the shuttingdown to shutting-down mode     - fixed the Gem warning on using Gem.find_by_name instead of       Gem::Specification. *thanks Patrick Debois*
*   Added a way to filter the active and the defined servers(domains) using     - servers.all(:active => false, :defined=> true). *thanks Patrick Debois*
*   Fixed empty filter issue, nil filter. *thanks Patrick Debois*
*   * Fixed an error with memory_size 256       that should be 256*1024 as the default is K nor M     * Changed the ip_command to check the ipaddress to include changes not     * only new IPaddresses. *thanks Patrick Debois*
*   Added libvirt options to credentials error. *thanks Patrick Debois*
*   Made libvirt username param consistent with other providers libvirt_user -> libvirt_username. *thanks Patrick Debois*
*   [Libvirt] Provided better solution for ip_command : use shell variable instead of ruby string for mac-address. *thanks Patrick Debois*
*   vmfusion provider , requires the fission gem (pull request pending). *thanks Patrick Debois*
*   fixed missing disk-> volume conversion. *thanks Patrick Debois*
*   another log entry style resused old ethernet. *thanks Patrick Debois*
*   Fix warning about whitespace before parentheses in dns.rb. *thanks Rick Bradley*
*   Added support fo canned ACLs in put_object_acl. *thanks dblock*
*   Updated put_bucket_acl to support canned ACLs. *thanks dblock*
*   Marking as pending. *thanks dblock*
*   Refactored specs, mocks, etc. *thanks dblock*
*   Revert "[core] make sure credentials tests properly reset after completion". *thanks geemus*
*   Update gemspec description to mention popular services that are supported. *thanks watsonian*

#### [ninefold|compute]
*   fixes for list formats. *thanks geemus*
*   fix for network formats. *thanks geemus*
*   add default (ubuntu) image for servers. *thanks geemus*

#### [rackspace|dns]
*   all important domains requests. *thanks Brian Hartsock*
*   zone models. *thanks Brian Hartsock*
*   records requests. *thanks Brian Hartsock*
*   record models. *thanks Brian Hartsock*
*   minor docs update. *thanks Brian Hartsock*
*   add mock initializer. *thanks geemus*
*   consistency fixes and tests and mark pending in mocked. *thanks geemus*
*   fix mock init to play nice with tests. *thanks geemus*
*   fixes for updates to beta. *thanks geemus*

#### [rackspace|load_balancers]
*   fix path for tests. *thanks geemus*
*   fixes for tests. *thanks geemus*

#### [rackspace|storage]
*   fix broken model paths. *thanks geemus*

#### [release]
*   update MVP skip list. *thanks geemus*
*   add collaborator count to changelog stats. *thanks geemus*

#### [storage]
*   Fixed what appeared to be broken test (I only verified with Rackspace provider). *thanks Brian Hartsock*

#### [storage|aws]
*   Add options to File#copy method. *thanks Aaron Suggs*
*   move aws storage back with other aws stuff (namespacing should probably be recorrected as well). *thanks geemus*

#### [storage|google]
*   move google storage to shared google stuff (namespacing should probably be corrected). *thanks geemus*

#### [storage|local]
*   move local storage to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [storage|ninefold]
*   move ninefold storage to its own shared area (namespacing should probably be corrected). *thanks geemus*
*   use Fog::HMAC. *thanks geemus*

#### [storage|rackspace]
*   Fixed NotFound namespace. *thanks Grégory Karékinian*
*   move rackspace storage to its own shared area (namespacing should probably be corrected). *thanks geemus*

#### [tests]
*   rearrange to match new lib structure. *thanks geemus*
*   mark not implemented mocks as pending. *thanks geemus*
*   more helpful formats helper errors. *thanks geemus*

#### [vmfusion|compute]
*   fixed destroy function. *thanks Patrick Debois*
*   reworked structure as will be released in 0.4.0a. *thanks Patrick Debois*

#### [vsphere|compute]
*   mark test requiring guid pending, as require can not be found. *thanks geemus*
*   remove unnecessary mocha require. *thanks geemus*


## 0.11.0 08/18/2011
*Hash* 73bcee507a4732e071c58d85793b7f307eb377dc

Statistic     | Value
------------- | --------:
Collaborators |
Downloads     | 202791
Forks         | 237
Open Issues   | 20
Watchers      | 1427

**MVP!** Brian Hartsock

#### [aws|cdn]
*   Added commands for streaming distribution lists. *thanks Christopher Oliver*

#### [aws|compute]
*   describe security groups parser was not taking into account ipPermissionsEgress and therefore returning unexpected results when the account had VPC groups. *thanks Christopher Oliver*
*   Added missing 'platform' attribute to server model and describe instances request. *thanks Christopher Oliver*

#### [aws|iam]
*   fix 'Path' handling for get_group response. *thanks Nick Osborn*
*   add missing update_server_certificate request. *thanks Nick Osborn*

#### [aws|rds]
*   Allow string or symbol hash keys. *thanks Aaron Suggs*

#### [aws|s3]
*   Added basic tests for get_bucket, fixed a bug in get_bucket with delimiter option, tests succeed for both mocked and real situation. *thanks Erik Terpstra*
*   policy should be base64 encoded and not contain new lines. *thanks Fujimura Daisuke*
*   Require 'multi_json' was lucked. *thanks Fujimura Daisuke*

#### [compute]
*   add server base class to contain shared stuff (scp/ssh). *thanks geemus*

#### [compute|aws]
*   Whitespace removal. *thanks Dylan Egan*
*   Allow image mocks to support state (except failed). *thanks Dylan Egan*
*   fix pluralization of modify_image_attribute. *thanks geemus*
*   update modify image/snapshot attribute to match latest API. *thanks geemus*
*   add modify_image_attribute. *thanks geemus*
*   add support for saving assigned tags at server creation time. *thanks geemus*
*   add docs for new options on run_instances. *thanks geemus*
*   guard tag creation against empty tag set. *thanks geemus*
*   fixes for bootstrap and placing attributes json. *thanks geemus*
*   identity not needed for setup. *thanks geemus*
*   fix for running nice with mocked test run. *thanks geemus*

#### [compute|brightbox]
*   Updated test for new expected response from server. *thanks Paul Thornthwaite*
*   Updated Account format test to allow valid_credit_card flag. *thanks Paul Thornthwaite*
*   Added IPv6 address to format now it is exposed to API. *thanks Paul Thornthwaite*
*   DRY up request method. *thanks Paul Thornthwaite*
*   Corrected attribute name. *thanks Paul Thornthwaite*

#### [compute|voxel]
*   position in format is string, not integer. *thanks geemus*

#### [dns]
*   dry generate_unique_domain to tests helper. *thanks geemus*

#### [dns|dynect]
*   cleanup of initial implementation. *thanks geemus*
*   fixes to play nice with mocked test runs. *thanks geemus*

#### [dns|zerigo]
*   add host/port/scheme to recognizes. *thanks geemus*

#### [docs]
*   add task to build/publish supported services matrix. *thanks geemus*
*   alphasort doc tasks. *thanks geemus*

#### [misc]
*   if creating an s3 directory (bucket), one needs to pass in :location as well as have the aws connection set to the correct region... *thanks Adam Greene*
*   - Write files as binary (otherwise UTF8 - ASCII errors can occur)      - Check if File exists before trying to delete it (paperclip sometimes deletes files twice)      - Check if Directory exists before trying to "cd" into it. *thanks Andre Meij*
*   Fix issue 464, add howto for European Rackspace cloud. *thanks Andre Meij*
*   Initial support for adding/deleting a load balancer (requests only). *thanks Brian Hartsock*
*   Complete lifecycle for a load balancer. *thanks Brian Hartsock*
*   Improved error handling. *thanks Brian Hartsock*
*   Model and collection for load balancers. *thanks Brian Hartsock*
*   Fixed issues with loading all LB params. *thanks Brian Hartsock*
*   Requests for nodes. *thanks Brian Hartsock*
*   Rackspace Load Balancers: model classes for nodes. *thanks Brian Hartsock*
*   Rackspace Load Balancers: requests for virtual ips. *thanks Brian Hartsock*
*   Added virtual IP models. *thanks Brian Hartsock*
*   Rackspace LB: Made some updates from the pull request. *thanks Brian Hartsock*
*   Rackspace LB: protocols, algorithms, and connection logging. *thanks Brian Hartsock*
*   Added access list requests. *thanks Brian Hartsock*
*   Rackspace LB: Added session persistence requests. *thanks Brian Hartsock*
*   Rackspace LB: Connection throttling requests. *thanks Brian Hartsock*
*   Rackspace LB: Fixed issues with connection logging model. *thanks Brian Hartsock*
*   Rackspace LB: Health Monitor requests. *thanks Brian Hartsock*
*   Rackspace LB: account usage request. *thanks Brian Hartsock*
*   Rackspace LB: Load Balancer Usage requests. *thanks Brian Hartsock*
*   Rackspace LB: Added model capabilities for a lot of additional actions. *thanks Brian Hartsock*
*   Rackspace LB: models for access lists. *thanks Brian Hartsock*
*   Rackspace LB: account usage call. *thanks Brian Hartsock*
*   Rackspace LB: Refactoring and cleanup. *thanks Brian Hartsock*
*   register_image mocking support. *thanks Dylan Egan*
*   Remove GENTOO_AMI. *thanks Dylan Egan*
*   Store it under the ID, not the name. *thanks Dylan Egan*
*   Allow tag filtering for images. *thanks Dylan Egan*
*   Set imageOwnerAlias to self. Not 100% on this, but it will allow you to search for images with 'owner-alias' => 'self'. *thanks Dylan Egan*
*   Back to using Owner. A couple of tests for it too. *thanks Dylan Egan*
*   Added support for delimiter option in Fog::Storage::AWS::Mock object. *thanks Erik Terpstra*
*   Link to EBS snapshots blog post. *thanks Gavin Sandie*
*   Add force stop functionality to AWS Instance. *thanks John Ferlito*
*   * Changed LoadError to Fog::Error::LoadError when missing configuration     * When running from command line, rescue the exception, and print the help message. *thanks Mark A. Miller*
*   * Fix VirtualBox in compute case statement. *thanks Mark A. Miller*
*   Update to the latest VirtualBox gem while we're at it for good measure. *thanks Mark A. Miller*
*   add dynect DNS provider with session request implemented. *thanks Michael Hale*
*   add dynect provider and cleanup extra requires. *thanks Michael Hale*
*   enable mocking for dynect. *thanks Michael Hale*
*   parse session request and fix mock for tests. *thanks Michael Hale*
*   whoops forgot to add these files. *thanks Michael Hale*
*   temporary rake task for convenient testing. *thanks Michael Hale*
*   include /REST in all requests. *thanks Michael Hale*
*   change API-Token to Auth-Token. *thanks Michael Hale*
*   add zone request. *thanks Michael Hale*
*   fix API-Token in mock session request. *thanks Michael Hale*
*   always run both mock and non-mock tests. *thanks Michael Hale*
*   parse the list of zones returned. *thanks Michael Hale*
*   require builder in dynect. *thanks Michael Hale*
*   WIP:  add stub model classes. *thanks Michael Hale*
*   tests passing. *thanks Michael Hale*
*   rename zone request to zones. *thanks Michael Hale*
*   add zone request to show information for a single zone. *thanks Michael Hale*
*   hook up zones model. *thanks Michael Hale*
*   hook up zones.get. *thanks Michael Hale*
*   dynect: add a bunch of stuff: node_list, list_any_records, handle 307 job     redirect,. *thanks Michael Hale*
*   dynect: nicer filter api for records. *thanks Michael Hale*
*   Escape source object name when copying. *thanks Pratik Naik*
*   provide #providers for shared services. *thanks geemus*

#### [rackspace|load balancers]
*   fixed broken tests. *thanks Brian Hartsock*

#### [rackspace|load_balancers]
*   fixes to play nice with mock test runs. *thanks geemus*
*   fix typo in tests. *thanks geemus*

#### [rackspace|loadbalancers]
*   cleanup. *thanks geemus*

#### [release]
*   add newest MVP to changelog task MVP omit list. *thanks geemus*
*   add stats to changelog. *thanks geemus*
*   remove un-needed rebuild of gem. *thanks geemus*

#### [storage]
*   fix deprecated get_url usage. *thanks geemus*

#### [storage|aws]
*   simplify region accessor. *thanks geemus*

#### [storage|ninefold]
*   remove debug output. *thanks geemus*

#### [tests]
*   non-destructively generate id for get('fake') == nil tests. *thanks geemus*


## 0.10.0 07/25/2011
*Hash* 9ca8cffc000c417a792235438c12855a277fe1ce
MVPs! Christopher Oliver, Dylan Egan and Henry Addison

#### [AWS Autoscaling]
*   Fixed typo in put scaling policy request. *thanks Christopher Oliver*
*   Fixed error in describe policies parser. *thanks Christopher Oliver*
*   Got describe policies returning correctly. *thanks Christopher Oliver*
*   Removed unnecessary options merge in Delete Policy request. *thanks Christopher Oliver*

#### [AWS IAM]
*   Added Alias related functionality to IAM. Also added get_group_policy. *thanks Christopher Oliver*
*   Added missing request file for list account aliases. *thanks Christopher Oliver*

#### [AWS RDS]
*   Added describe db engine versions and describe db reserved instances. Changed the signed params version to 2011-04-01 from 2010-07-28. *thanks Christopher Oliver*
*   Added LicenseModel to the db_parser. *thanks Christopher Oliver*

#### [AWS|ELB]
*   fix bug that was causing availability zones to not parse properly on get/reload. *thanks Blake Gentry*
*   default values for Listeners. *thanks Blake Gentry*
*   offload Listener defaults to the Listener model. *thanks Blake Gentry*

#### [AWS|SNS]
*   flesh out basics. *thanks geemus*

#### [AWS|SQS]
*   flesh out basics. *thanks geemus*

#### [aws|auto_scaling]
*   implement 2010-08-01 API. *thanks Nick Osborn*

#### [aws|autoscaling]
*   metrics#get should return nil when not found. *thanks geemus*
*   mark unimplemented/unsupported tests as pending. *thanks geemus*

#### [aws|cloudwatch]
*   mark overly specific test as pending. *thanks geemus*

#### [aws|compute]
*   improve model and tests. *thanks Nick Osborn*

#### [aws|elb]
*   add test to verify that ListenerDescriptions work when creating an ELB. *thanks Blake Gentry*
*   make describe_load_balancers parse SSLCertificateId. Verify with test. *thanks Blake Gentry*
*   Raise proper IAM error for CertificateNotFound when creating an ELB or creating Listeners. *thanks Blake Gentry*
*   move ELB error handling related to certs to the ELB service instead of duplicating at the request level. *thanks Blake Gentry*
*   use slurp when raising errors to properly capture exception details. *thanks Blake Gentry*
*   Add set_load_balancer_listener_ssl_certificate. *thanks James Miller*
*   fix listener defaults to use merge_attributes and therefore aliases. *thanks geemus*

#### [aws|iam]
*   add error handling for common failures resulting from upload_server_certificate. *thanks Blake Gentry*
*   fix superclass mismatch. *thanks Blake Gentry*
*   add get_server_certificate request. *thanks Blake Gentry*
*   raise correct ValidationError when an empty cert or key is used. *thanks Blake Gentry*
*   Simplify error handling code for errors with custom classes. *thanks Blake Gentry*
*   raise EntityAlreadyExists when creating a duplicate cert name. *thanks Blake Gentry*
*   tests and mocks to support many types of key/cert issues. *thanks Blake Gentry*
*   add proper error messages. *thanks Blake Gentry*
*   fix expected error result from login_profile_tests. *thanks geemus*

#### [aws|rds]
*   add LicenseModel to format. *thanks geemus*

#### [aws|simpledb]
*   provide for using ConsistentRead on get_attributes and select. *thanks geemus*
*   fix get_attributes mock deprecation. *thanks geemus*

#### [compute]
*   fix stormondemand namespace mismatch. *thanks geemus*

#### [compute|aws]
*   cluster compute placement group implementation. *thanks geemus*
*   add request level support for spot instances. *thanks geemus*
*   fix describe_instances parser to get group ids correctly. *thanks geemus*
*   fix compute accessor in tests. *thanks geemus*

#### [compute|bluebox]
*   fixes for ip accessor usage. *thanks geemus*

#### [compute|brightbox]
*   Fixed typo in deprecation warning. *thanks Paul Thornthwaite*
*   Fixed deprecated use of Brightbox[:compute] to new Compute[:brightbox]. *thanks Paul Thornthwaite*
*   New preference exposed in API added to format test. *thanks Paul Thornthwaite*

#### [compute|ninefold]
*   add default serviceofferingid (flavor). *thanks geemus*
*   fix zone format. *thanks geemus*
*   small consistency fixes for server. *thanks geemus*

#### [compute|rackspace]
*   fix for token expiry/reauth. *thanks geemus*

#### [compute|virtualbox]
*   backwards compatibility for gem availability check. *thanks geemus*

#### [compute|voxel]
*   fix server format. *thanks geemus*

#### [core]
*   avoid ArgumentError with Ruby 1.8.5 on CentOS. *thanks Nick Osborn*
*   fix to_date_header to use self.utc instead of self.class.now.utc. *thanks geemus*
*   avoid ||= in timeout lookup. *thanks geemus*

#### [docs]
*   update index to use non-deprecated service accessor. *thanks geemus*

#### [misc]
*   Fix ::AWS[] syntax that's only valid in Fog tests when bin/aws.rb is loaded. *thanks Blake Gentry*
*   Typos. *thanks Blake Gentry*
*   Require json needed for both Real and Mock implementation of Rackspace; SSH commands in Mock just print to command line. *thanks Brian Hartsock*
*   Revert "Require json needed for both Real and Mock implementation of Rackspace; SSH commands in Mock just print to command line". *thanks Brian Hartsock*
*   require json for rackspace compute mock. *thanks Brian Hartsock*
*   Fixed #444 - Unable to squash kvp with false values. *thanks Brian Hartsock*
*   Fix make OpenStack swift working properly. *thanks Chmouel Boudjnah*
*   Move the timeout to Mock and stop hardcoding. *thanks Christopher Meiklejohn*
*   Fix failures in the simpledb testing due to attribute array option deprecation. *thanks Christopher Meiklejohn*
*   Guard against item_name not being a valid key. *thanks Christopher Meiklejohn*
*   Switch to the has_key? syntax for cleanliness. *thanks Christopher Meiklejohn*
*   Move timeout up to Fog from Fog::Mock. *thanks Christopher Meiklejohn*
*   Fix deprecation messages. *thanks Claudio Poli*
*   Make Rails' respond_with play nice with to_json. *thanks Claudio Poli*
*   Use multi_json gem. *thanks Claudio Poli*
*   Public API for force_detach on Fog::Compute::AWS::Volume. *thanks Dylan Egan*
*   Should actually use the attachment_aliases hash. *thanks Dylan Egan*
*   server method for Fog::Compute::AWS::Volume to easily get the server instance. *thanks Dylan Egan*
*   requires_one, allows you to require at least one of the specified attributes. *thanks Dylan Egan*
*   Remove pending on iam/server_certificate_tests. Start the mocking. *thanks Dylan Egan*
*   list_server_certificates and delete_server_certificates. *thanks Dylan Egan*
*   Yes, yes it is better. *thanks Dylan Egan*
*   Start ELB mocks. Support create_load_balancer and describe_load_balancers. *thanks Dylan Egan*
*   configure_health_check and create_app_cookie_stickiness_policy. *thanks Dylan Egan*
*   create_lb_cookie_stickiness_policy and delete_load_balancer_policy. *thanks Dylan Egan*
*   create_load_balancer_listeneners and set_load_balancer_policies_of_listener. *thanks Dylan Egan*
*   delete_load_balancer_listeners and delete_load_balancer (with two more tests). *thanks Dylan Egan*
*   deregister_instances_from_load_balancer, describe_instance_health, disable_availability_for_load_balancer, enable_availability_zones_for_load_balancer, register_instances_with_load_balancer and updates to others to get ELB model_tests working. *thanks Dylan Egan*
*   Remove requirement of basic parsers. *thanks Dylan Egan*
*   Move things around a bit. Separate ELB test file per concerns. *thanks Dylan Egan*
*   SSL for ELB mocking. *thanks Dylan Egan*
*   Tested against AWS. Needed this. Apparently SSLCertificateId == Arn. *thanks Dylan Egan*
*   Use available availability_zones. *thanks Dylan Egan*
*   Wait for volume to be ready again. *thanks Dylan Egan*
*   AWS instance tests 100% against real. *thanks Dylan Egan*
*   Make stuff pending if you're mocking. Need to fix spot_price_history_tests, see comment. *thanks Dylan Egan*
*   Let's just sleep forever. *thanks Dylan Egan*
*   Reinstate ipAddress and privateIpAddress as they're provided for non-terminated instances. *thanks Dylan Egan*
*   Reinstate ramdiskId. *thanks Dylan Egan*
*   Revert "Reinstate ramdiskId." - fuckit! Seems like AWS doesn't return     ramdiskId for. *thanks Dylan Egan*
*   Clean up timeout and add tests. *thanks Dylan Egan*
*   Quick fix, ith != i. *thanks Dylan Egan*
*   Begin work on mocking reserved instances. Provide describe_reserved_instances_offerings for mocking and real. REAL TALK. *thanks Dylan Egan*
*   reserved_instances mocking. I think, it's hard to test against a real AWS account since it costs money. *thanks Dylan Egan*
*   Default to 1. *thanks Dylan Egan*
*   add spot instance request models. *thanks Edward Middleton*
*   fixed spot_requests. *thanks Edward Middleton*
*   spot instance fixes. *thanks Edward Middleton*
*   cloud_watch toplevel. *thanks Frederick Cheung*
*   add get/put/list metrics. *thanks Frederick Cheung*
*   Corrected a couple of syntax errors in the put and get metric cloudwatch requests. *thanks Henry Addison*
*   Fixed the parser for list metrics cloudwatch request. *thanks Henry Addison*
*   Added first test of successful list metrics. *thanks Henry Addison*
*   simplified a bit the long case statement in end element in list_metrics parser. *thanks Henry Addison*
*   added a few more cloudwatch request metric tests. *thanks Henry Addison*
*   added metrics collection and model for cloudwatch with all and get methods. *thanks Henry Addison*
*   split out and got passing get metric statistics request tests. *thanks Henry Addison*
*   Added metric statistics model and collection. *thanks Henry Addison*
*   removed old test file. *thanks Henry Addison*
*   removed empty test for for metric model (nothing to test at the moment). *thanks Henry Addison*
*   removed unnecessary attributes from metrics collection (naughty copy and pasting). *thanks Henry Addison*
*   got put_metric_data request working and tested. *thanks Henry Addison*
*   added model and collection methods and tests to allow putting of metric data. *thanks Henry Addison*
*   renamed argument for all method in cloud watch metric_statistics from filters to conditions as filters has a meaning in fog. *thanks Henry Addison*
*   added a conditions method to all metrics method to help filter all metrics. *thanks Henry Addison*
*   Added some defaults for StartTime, EndTime and Period to model for MetricStatistics. *thanks Henry Addison*
*   Begin SQS support. *thanks Jon Crosby*
*   Continued SQS support. *thanks Jon Crosby*
*   Add SQS get_queue_attributes. *thanks Jon Crosby*
*   Fix rubygems warning. *thanks Jonas Pfenniger*
*   Patch for AWS S3 Metadata problem. *thanks Kenji Kabashima*
*   Changed number of cores reported for rackspace flavors in order     to match current rackspace documentation. *thanks Steven Danna*
*   Checking path for nil. *thanks Timothy Klim*
*   Fixed escaping in Fog::AWS.escape. *thanks croaker*
*   Changed the encoding of the space character. *thanks croaker*
*   rebuild gemfile during release to include updated changelog. *thanks geemus*
*   bump excon dep. *thanks geemus*
*   loosen dependencies to avoid conflicts. *thanks geemus*
*   bump formatador dep. *thanks geemus*
*   to_json calls to use MultiJson. *thanks geemus*
*   make collection class_eval more consistent. *thanks geemus*
*   update gem deps to latest/greatest. *thanks geemus*
*   Return nil if HOME is non-absolute. Fixes #397. *thanks jc00ke*
*   Fix a bunch of paths. *thanks phiggins*
*   Start of SNS. *thanks phiggins*
*   Working ListUsers for SNS. *thanks phiggins*
*   Remove copied-and-pasted documentation. *thanks phiggins*
*   Add SNS's get_topic_attributes command. *thanks phiggins*
*   SNS ListSubscriptions. *thanks phiggins*
*   SNS ListSubscriptionsByTopic. *thanks phiggins*
*   SNS CreateTopic and DeleteTopic. *thanks phiggins*
*   SNS Publish. *thanks phiggins*
*   SNS AddPermission. *thanks phiggins*
*   SNS RemovePermission. *thanks phiggins*
*   SNS SetTopicAttributes. *thanks phiggins*
*   SNS Subscribe. *thanks phiggins*
*   SNS ConfirmSubscription and Unsubscribe. *thanks phiggins*
*   Add sns to fog bin. *thanks phiggins*
*   Start SNS tests. *thanks phiggins*

#### [ninefold|storage]
*   Framework + request method for Ninefold storage. *thanks Lincoln Stoll*
*   Directories Functionality. *thanks Lincoln Stoll*
*   Nested directories. *thanks Lincoln Stoll*
*   File operations. *thanks Lincoln Stoll*
*   Update an existing file. *thanks Lincoln Stoll*
*   set content type correctly. *thanks Lincoln Stoll*

#### [release]
*   add mvps and fix fog.io uploader. *thanks geemus*
*   remove problematic pbcopy from changelog rake task. *thanks geemus*
*   make changelog build separate from release. *thanks geemus*

#### [storage]
*   provide http/https options for signed urls. *thanks geemus*

#### [storage|aws]
*   properly format modified headers in get_object. *thanks geemus*
*   fix escaping for file#public_url. *thanks geemus*

#### [storage|google]
*   fix get_object_https_url namespace copy/paste error. *thanks geemus*

#### [storage|ninefold]
*   fix file#destroy and test cleanup. *thanks geemus*

#### [storage|rackspace]
*   add large object support via put_object_manifest. *thanks geemus*
*   cleanup formatting/style. *thanks geemus*

#### [tests]
*   make unimplemented mock tests pending. *thanks geemus*
*   fix collection helper to play nice with numeric ids. *thanks geemus*
*   replace letters with letters and numbers with numbers in collection#get failure test. *thanks geemus*

#### [vcloud|compute]
*   create server now takes :catalog_items_uri as an option. *thanks Kunal Parikh*
*   now referencing catalog_item_uri from options. *thanks Kunal Parikh*
*   saving server attributes (uncommented code). *thanks Kunal Parikh*
*   Revert "saving server attributes (uncommented code)". *thanks Kunal Parikh*
*   duplicate ecloud code for vcloud, remove obvious terremark specific code. *thanks Lincoln Stoll*
*   update catalog models for 1.0. *thanks Lincoln Stoll*
*   make auth work. *thanks Lincoln Stoll*
*   filter non-server items from server list. *thanks Lincoln Stoll*
*   update for 1.0 functionality, server operations working. *thanks Lincoln Stoll*
*   use correct power status ID for 'off'. *thanks Lincoln Stoll*
*   allow specifying a default VDC uri as 'vcloud_default_vdc'. *thanks Lincoln Stoll*
*   Add description field to server model. *thanks Lincoln Stoll*
*   Correct friendly status power off check. *thanks Lincoln Stoll*
*   correct hardware attribute reading. *thanks Lincoln Stoll*
*   no longer possible to specify memory & cpu on vapp creation. *thanks Lincoln Stoll*
*   remove outdated/invalid mocking & specs. *thanks Lincoln Stoll*
*   fix deleting servers. *thanks Lincoln Stoll*
*   server creation outside of VDC. *thanks Lincoln Stoll*
*   undeploy request. *thanks Lincoln Stoll*
*   memory reconfiguration. *thanks Lincoln Stoll*
*   make status/ready handling more reliable. *thanks Lincoln Stoll*
*   server tests. *thanks Lincoln Stoll*
*   only require template name for tests. *thanks Lincoln Stoll*
*   add and remove disks. *thanks Lincoln Stoll*
*   ruby 1.8 compatibility. *thanks Lincoln Stoll*
*   fix error messages in test helper. *thanks Lincoln Stoll*
*   Fix setting of description. *thanks Lincoln Stoll*
*   method to find catalog item by name across all catalogs. *thanks Lincoln Stoll*
*   correct provider lookup. *thanks Lincoln Stoll*


## 0.9.0 06/24/2011
*Hash* 32960d165a65f12d41785f924e6b6b6d8442516a
MVPs! Lincoln Stoll and Luqman Amjad

#### [aws]
*   use AWS.escape instead of CGI.escape. *thanks geemus*

#### [aws|compute]
*   Use #public_ip_address instead of deprecated #ip_address in Server#setup. *thanks Martin Emde*
*   mock: make address detach others before associating. *thanks geemus*

#### [aws|elb]
*   Fix failing created_at test caused by Ruby 1.9 changes to     Range#include?. Use simpler test that doesn't care about the exact     created_at time. *thanks Blake Gentry*
*   Update ELB API to version 2011-04-05. *thanks Blake Gentry*
*   Fix typo in usage documentation and add 'ap-northeast-1' to     regions list. *thanks Blake Gentry*
*   Rearrange DescribeLoadBalancersResult contents to alphabetical order to match the official AWS docs and make it easier to update the list. *thanks Blake Gentry*
*   Add new attributes for 2011-04-05 API. *thanks Blake Gentry*

#### [aws|rds]
*   Add parameter group tests. *thanks Aaron Suggs*
*   Add server model & collection tests. *thanks Aaron Suggs*
*   Add security_groups collection and model tests. *thanks Aaron Suggs*
*   Server#destroy argument is optional. *thanks Aaron Suggs*
*   Refactor RDS model & collection tests. *thanks Aaron Suggs*

#### [aws|simpledb]
*   recognize :region option in SimpleDB.new(). *thanks Nick Osborn*

#### [aws|storage]
*   Add get/put bucket policy support. *thanks Michael Linderman*
*   Add options argument to delete_object to set headers. *thanks Michael Linderman*
*   Add delete bucket policy. *thanks Michael Linderman*
*   discern between no file and no directory for files.get. *thanks geemus*
*   fix error type for non-directories in files.get. *thanks geemus*

#### [brightbox|compute]
*   Added missing Image#compatibility_mode attribute. *thanks Paul Thornthwaite*
*   Fixed Format of Account representation. *thanks Paul Thornthwaite*
*   Fixed Format of nested CloudIP's server attribute. *thanks Paul Thornthwaite*
*   New account limits exposed in API, updating format test. *thanks Paul Thornthwaite*
*   ApiClient revoked time exposed in API. Updated format test. *thanks Paul Thornthwaite*

#### [cdn]
*   refactor provider/service namespacing. *thanks geemus*
*   fix top level class/module mismatch. *thanks geemus*

#### [compute]
*   first pass at examples. *thanks geemus*
*   refactor provider/service namespacing. *thanks geemus*
*   fixes/skips to get examples working. *thanks geemus*

#### [compute|aws]
*   fix helpers to use Fog::AWS. *thanks geemus*
*   simplify describe_instances parser. *thanks geemus*
*   fix deprecated compute service accessor usage. *thanks geemus*
*   improve consistency of waiting for ssh to be ready. *thanks geemus*
*   remove debug output from last commit. *thanks geemus*

#### [compute|bluebox]
*   fix format and template id in tests. *thanks geemus*

#### [compute|brightbox]
*   Fixed missed lookup in broken tests caused by namespace rename. *thanks Paul Thornthwaite*

#### [compute|ecloud]
*   fix namespace leftovers. *thanks geemus*

#### [compute|ninefold]
*   test cleanup. *thanks geemus*

#### [compute|rackspace]
*   fix nil check for auth token. *thanks geemus*

#### [compute|stormondemand]
*   fix namespace issue. *thanks geemus*

#### [compute|voxel]
*   fix flavor tests to properly skip voxel. *thanks geemus*
*   fix namespace issue. *thanks geemus*

#### [core]
*   add namespaced errors for better messaging. *thanks geemus*
*   making collection.new error more idiomatic. *thanks geemus*
*   fix mock reset to work with new namespaces. *thanks geemus*

#### [dns]
*   rename ip to value for record. *thanks geemus*
*   refactor provider/service namespacing. *thanks geemus*

#### [dns|dnsmadeeasy]
*   skip model/collection tests for now (timing issue). *thanks geemus*

#### [dns|examples]
*   fix deprecated record#ip= usage. *thanks geemus*

#### [dns|zerigo]
*   fixes for namespacing. *thanks geemus*
*   namespace related fixes. *thanks geemus*

#### [docs]
*   main index redirects to /latest. *thanks geemus*
*   fix rdoc link on index. *thanks geemus*
*   update to match refactorings. *thanks geemus*

#### [examples]
*   fix descriptions. *thanks geemus*

#### [linode|compute]
*   mark format test for stackscripts pending due to inconsistency of string/float for a value. *thanks geemus*

#### [misc]
*   add braces for new  into the documents. *thanks Chris Mague*
*   use correct variable name in test description. *thanks Dr Nic Williams*
*   Not sure if I'm missing something here, but rake did not work. *thanks Dylan Egan*
*   You only need either the size or the snapshot_id. *thanks Dylan Egan*
*   Provide mocked console output if server has been up for over the delay time. *thanks Dylan Egan*
*   LIES!. *thanks Dylan Egan*
*   Add support for specifying a CDN CNAME when getting a Rackspace Cloud Files directory. *thanks H. Wade Minter*
*   add missing comma. *thanks Joseph Anthony Pasquale Holsten*
*   skip rackspace get_object test when mocking. *thanks Joseph Anthony Pasquale Holsten*
*   give a more useful error if someone tries to say connection.directories.create('dir'). *thanks Joseph Anthony Pasquale Holsten*
*   Added my blog post. *thanks Larry Wright*
*   Add recursive argument to server scp methods. Set to false by default. *thanks Luke Robins*
*   Add an options hash to scp. Set to {} by default. *thanks Luke Robins*
*   Added new DNS provider => DNS Made Easy. *thanks Luqman Amjad*
*   Removed sandbox url for DNS Made Easy. *thanks Luqman Amjad*
*   Added missing method "delete all domains". *thanks Luqman Amjad*
*   (DNSMadeEasy) added support for updating records via PUT. *thanks Luqman Amjad*
*   Added missing reference to delete_all_domains. *thanks Luqman Amjad*
*   Rescue 404 when fetching zone. *thanks Luqman Amjad*
*   Added new blog posting about fog and Carrierwave. *thanks Mike Gehard*
*   Edited docs/about/press.markdown via GitHub. *thanks Mike Gehard*
*   Typo fix. *thanks Oge Nnadi*
*   Fixed Fog::AWS::SimpleDB#delete_attributes. *thanks Pan Thomakos*
*   add Net::SCP options parameter to Fog::SCP proxy. *thanks Phil Cohen*
*   use a hash not nil for default scp_options. *thanks Phil Cohen*
*   rackspace auth url only prepend protocol as needed. *thanks Todd Willey*
*   Allow auth tokens to be shared among connections to rackspace api. *thanks Todd Willey*
*   OpenStack responds 200 when creating servers. *thanks Todd Willey*
*   added 0.8.2 changelog contents. *thanks geemus*
*   separate fog.io and rdoc tasks. *thanks geemus*
*   remove provider attribute from shared services. *thanks geemus*
*   [storage][aws] fix leftover namespace mismatch. *thanks geemus*
*   [storage][google] fix leftover namespace mismatch. *thanks geemus*
*   Edited lib/fog/storage/rackspace.rb via GitHub. *thanks kbockmanrs*

#### [ninefold|compute]
*   Boilerplate for ninefold. *thanks Lincoln Stoll*
*   Ninefold List Functionality. *thanks Lincoln Stoll*
*   VM Operations + dependencies. *thanks Lincoln Stoll*
*   Fix data formats for virtual machines. *thanks Lincoln Stoll*
*   IP Address requests. *thanks Lincoln Stoll*
*   Refactor out job waiting functionality, test correct data. *thanks Lincoln Stoll*
*   NAT functionality. *thanks Lincoln Stoll*
*   Core model functionality. *thanks Lincoln Stoll*
*   Public IPs and Rules. *thanks Lincoln Stoll*
*   use lowest network ID as default, correct assignment. *thanks Lincoln Stoll*
*   No mocks, simplify code. *thanks Lincoln Stoll*
*   Save operations not supported. *thanks Lincoln Stoll*

#### [rake]
*   add examples back into default rake task. *thanks geemus*

#### [release]
*   update changelog during release process. *thanks geemus*

#### [storage]
*   refactor provider/service namespacing. *thanks geemus*

#### [storage|aws]
*   more robust query handling for signed url. *thanks geemus*
*   make url a bit more robust. *thanks geemus*
*   fix url to check for query. *thanks geemus*
*   fix whitespace errors. *thanks geemus*
*   more precise mocked get_object. *thanks geemus*

#### [storage|rackspace]
*   fix files#get_url. *thanks geemus*

#### [tests]
*   add dnsmadeeasy and ninefold to mock credentials. *thanks geemus*
*   nuke rake task for test related cleanup. *thanks geemus*
*   make collection gsub to find nils a bit more resilient/unique. *thanks geemus*
*   trying again to make collection gsub to get nils more resilient/unique. *thanks geemus*


## 0.8.2 05/26/2011
*Hash* 9e6ebb6f7316273eb489f8cb60eb1642e6df357b
**MVP!** nightshade427

#### [aws|compute]
*   better region/zone handling for mocks. *thanks geemus*
*   indentation fix for last commit. *thanks geemus*
*   add class level reset for Fog::AWS::Compute::Mock. *thanks geemus*
*   make mock delay comparison >= so that delay 0 will work properly. *thanks geemus*
*   respect security zone choice in mocked run_instances     closes #314. *thanks geemus*
*   respect key_name in mocked run_instances. *thanks geemus*
*   fix instance format in tests. *thanks geemus*

#### [brightbox|compute]
*   fix format for account in tests. *thanks geemus*

#### [compute]
*   Test server reloading. *thanks Aaron Suggs*
*   consistency in #state call and mock test fixes. *thanks geemus*

#### [compute|aws]
*   Fix server tests. *thanks Aaron Suggs*
*   Mock get_password_data request. *thanks Aaron Suggs*
*   Fix default region when mocking. *thanks Aaron Suggs*
*   Better key_pair tests. *thanks Aaron Suggs*
*   Make volumes format more flexible. *thanks Aaron Suggs*

#### [core]
*   Fixed credential tests. *thanks Aaron Suggs*
*   Fix responds_to test helper. *thanks Aaron Suggs*
*   omit Release commits from changelog. *thanks geemus*
*   put changelog in clipboard to finish release. *thanks geemus*
*   more consistent redirector for fog.io. *thanks geemus*
*   create Fog.available_providers for bin rather than overriding Fog.providers. *thanks geemus*

#### [dnsimple|dns]
*   add dnsimple_url param to facilitate using https://test.dnsimple.com     closes #323. *thanks geemus*

#### [docs]
*   first pass at compute doc. *thanks geemus*
*   update version in header/layout. *thanks geemus*
*   also build/deploy rdocs. *thanks geemus*
*   make fog.io/latest/foo link to newest versioned docs. *thanks geemus*

#### [ecloud]
*   mark bin specs pending unless credentials provided     closes #325. *thanks geemus*

#### [local|storage]
*   fixes for pending mocked tests. *thanks geemus*

#### [misc]
*   Flatten list of security groups. *thanks Dan Peterson*
*   Added an example of the head method. *thanks Larry Wright*
*   Clarified my example. *thanks Larry Wright*
*   Add a link to fog's Rubydocs. *thanks Mathias Meyer*
*   :size should be a number in GB, not an instance size (e.g. t1.micro). *thanks Michael Conigliaro*
*   tests. *thanks Nicholas Ricketts*
*   added rdoc comments. *thanks Nicholas Ricketts*
*   Add Amazon API reference link to requests' documentation. *thanks Peter Weldon*
*   Add reset method to mock classes. *thanks anomalousthought*
*   Add a reset method to Fog::Mock that resets all providers/services. *thanks anomalousthought*
*   Add reset method to other providers in addition to Compute providers. *thanks anomalousthought*
*   Add a reset method to Fog::Mock that resets all providers/services in addition to Compute providers. *thanks anomalousthought*
*   Public key results are cached, avoid a bug by using that cache. *thanks bigfleet*
*   0.8.1 changelog. *thanks geemus*
*   messy first pass at parallelization of testing. *thanks geemus*
* fix deprecated rdoc rake tasks. *thanks geemus*
* add mvp suggestion to changelog task. *thanks geemus*
*   started linode models. *thanks nightshade427*
*   added images models. *thanks nightshade427*
*   added kernel modes. *thanks nightshade427*
*   added datacenters models. *thanks nightshade427*
*   server provisioning completed. *thanks nightshade427*
*   server creation and deletion working. *thanks nightshade427*
*   generalize code. *thanks nightshade427*
*   creating via stackscripts with callbacks working. *thanks nightshade427*
*   added shutdown, reboot, boot. *thanks nightshade427*
*   made config private. *thanks nightshade427*
*   tests passing. *thanks nightshade427*
*   revert tests to proper error codes, waiting on fix from linode to support correct error codes. *thanks nightshade427*
*   code cleanup, tests passing. *thanks nightshade427*
*   more passing tests. *thanks nightshade427*
*   more test passing. *thanks nightshade427*
*   more test passing. *thanks nightshade427*
*   more test passing. *thanks nightshade427*
*   more test passing. *thanks nightshade427*
*   more test passing. *thanks nightshade427*

#### [mock]
*   fix Fog::Mock.reset. *thanks Dan Peterson*
*   error sooner for completely unimplemented services. *thanks geemus*
*   cleanup and reset related fixes. *thanks geemus*

#### [rackspace|compute]
*   make mocks respect Fog::Mock.delay. *thanks geemus*

#### [storage]
*   fix/consolidate content-length for utf8. *thanks geemus*

#### [tests]
*   add additional fake credentials for mocked tests. *thanks geemus*

#### [voxel|compute]
*   fix format for servers in tests. *thanks geemus*


## 0.8.1 05/13/2011
*Hash* 3a452347a396f0ad1fea7f5475fb3c349b10f527
#### [aws|compute]
*   less confusing explanation comment. *thanks geemus*

#### [compute|aws]
*   Fix describe_instances filtering. *thanks ktheory*
*   Add get_password_data request. *thanks ktheory*

#### [core]
*   Add test for Fog::Parsers::Base. *thanks ktheory*
*   handle busted ENV['HOME']. *thanks pfalcone     closes #301. thanks geemus*
*   update fog.io in release task. *thanks geemus*
*   add hash to changelog. *thanks geemus*
*   work toward automating changelog. *thanks geemus*
