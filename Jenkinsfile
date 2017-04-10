#!/usr/bin/env groovy

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.buildProject()

  def image = docker.build "govuk/content-store:${env.BRANCH_NAME}"
  // docker.withRegistry('https://index.docker.io/v1/', 'govukci-docker-hub') {
    image.push()

    if (env.BRANCH_NAME == 'master') {
      image.push("release_${env.BUILD_NUMBER}", 'govukci-docker-hub')
    }
  // }
}
