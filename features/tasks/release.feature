Feature: Releasing the Fog gem

  In order to start contributing to Fog via GitHub
  As a Fog contributor
  I should have the project and git setup to release versions to the git repo

  Background:
    Given the Fog project folder is the current folder
    And I want bundler
    And I configured git sanely
    And the repository status is clean

#  TODO: Scenario: Fog pre-release checks
#    - README.rdoc
#    - Cucumber feature and Rspec docs pushed to gh-pages
#    - License credits
#    - License copyright year

  @fakefs @vcs
  Scenario: Fog major release
    Given the current version numbers
    When I run the "major" release task
    Then the updated version file is checked in
      And the repository status is clean

  @fakefs @vcs
  Scenario: Fog minor release
    Given the current version numbers
    When I run the "minor" release task
    Then the updated version file is checked in
      And the repository status is clean

  @fakefs @vcs
  Scenario: Fog patch release
    Given the current version numbers
    When I run the "patch" release task
    Then the updated version file is checked in
      And the repository status is clean

  @fakefs @vcs
  Scenario: Fog build release
    Given the current version numbers
    When I run the "build" release task
    Then the updated version file is checked in
      And the repository status is clean

  @fakefs @vcs
  Scenario: Fog custom release
    Given the current version numbers
    When I run the "custom" release task
    Then the updated version file is checked in
      And the repository status is clean

