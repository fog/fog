Feature: Bumping version numbers

  Background:
    Given the Fog project folder is the current folder
      And the BDD helper methods are available

  Scenario: Bump the major version
    Given the current version numbers
    When the "major" version is bumped
    Then the "major" version constant is bumped similarly
      And the "major" version attribute is bumped similarly
      And the version string is updated

  Scenario: Bump the minor version
    Given the current version numbers
    When the "minor" version is bumped
    Then the "minor" version constant is bumped similarly
      And the "minor" version attribute is bumped similarly
      And the version string is updated

  Scenario: Bump the patch version
    Given the current version numbers
    When the "patch" version is bumped
    Then the "patch" version constant is bumped similarly
      And the "patch" version attribute is bumped similarly
      And the version string is updated

  Scenario: Bump the build version
    Given the current version numbers
    When the "build" version is bumped
    Then the "build" version constant is bumped similarly
      And the "build" version attribute is bumped similarly
      And the version string is updated

