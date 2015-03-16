# Getting Started Examples

## Download

Examples using the Rackspace Open Cloud and Fog can be found in the [fog repository](https://github.com/fog/fog) under the directory `fog/lib/fog/rackspace/examples`.

This repository can be downloaded via `git` by executing the following:

	git clone git://github.com/fog/fog.git

Optionally you can download a zip by clicking on this [link](https://github.com/fog/fog/archive/master.zip).

## Requirements

Examples require the following:

* Rackspace Open Cloud account
* Ruby 1.8.x or 1.9.x
* `fog` gem

For more information please refer to the [Getting Started with Fog and the Rackspace Open Cloud](https://github.com/fog/fog/blob/master/lib/fog/rackspace/docs/getting_started.md) document.

## Credentials

Examples will prompt for Rackspace Open Cloud credentials. Prompts can be skipped by creating a `.fog` file in the user's home directory. This is an example of a `.fog` file for the Rackspace Open Cloud:

	default:
    	rackspace_username: RACKSPACE_USERNAME
    	rackspace_api_key: RACKSPACE_API_KEY

**Note:** Replace capitalized values with the appropriate credential information.

## Executing

To execute scripts using `bundler`:

	bundle exec ruby <script>
	
To execute scripts without `bundler`:

	ruby <script>
	
## Support and Feedback

Your feedback is appreciated! If you have specific issues with the **fog** SDK, developers should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.
