# Release process

This is fog's current release process, documented so people know what is
currently done.

## Versioning

fog uses semantic versioning (http://semver.org/)

## When we release

Releases occur monthly and are manually handled by fog's Benevolent
Dictator Wes (@geemus).

To request a new release please raise an issue.

## Prepare the release

* Ensure the code is passing on the CI server [![Build Status](https://secure.travis-ci.org/fog/fog.png?branch=master)](http://travis-ci.org/fog/fog)
* Ensure the code is passing for live tests (Requires Credentials for all
services)
* Ensure working on **master**
* Update the version number (`lib/fog/version.rb`)
* Run `rake changelog` to update `changelog.txt`
* Run `rake release` to prepare the release which does:
  * Builds the gem (`rake build`)
  * Tags the commit
  * Creates commits for version and pushes to github (Requires
Credentials)
  * Pushes gem to rubygems (Requires Credentials)
  * Creates site documentation (`rake docs`)
  * Pushes site documentation to S3 (Requires Credentials)

## Announce the release

Once the release is prepared and uploaded it needs to be announced.

* Send an email to https://groups.google.com/forum/?fromgroups#!forum/ruby-fog
* Tweet as @fog on Twitter (Requires Credentials)
