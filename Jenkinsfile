#!/usr/bin/env groovy

DEFAULT_PUBLISHING_E2E_TESTS_BRANCH = "master"

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.buildProject(
    e2eTests: true,
    appName: "CONTENT_STORE",
    e2eTestBranch: DEFAULT_PUBLISHING_E2E_TESTS_BRANCH
  )
}
