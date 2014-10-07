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
* Run `rake changelog` to update `CHANGELOG.md`
* Run `rake release` to prepare the release which does:
  * Prepares the release (`rake release:prepare`)
    * Builds the gem
    * Tags the commit
    * Creates commits for version
  * Publishes the release (`rake release:publish`)
    * Pushes commit and tag to Github (Requires Credentials)
    * Pushes gem to Rubygems (Requires Credentials)
* Run `rake github_release` to add release to [github release feed](https://github.com/fog/fog/releases.atom) (Requires Credentials)

## Announce the release

Once the release is prepared and uploaded it needs to be announced.

* Send an email to https://groups.google.com/forum/?fromgroups#!forum/ruby-fog
* Tweet as @fog on Twitter (Requires Credentials)
