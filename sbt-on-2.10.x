# Warning: THIS FILE IS USED IN PR VALIDATION. DO NOT MODIFY WITHOUT
#          NOTIFYING SCALA, SCALA-IDE TEAMS
#  Nightly job: https://jenkins-dbuild.typesafe.com:8499/job/sbt-nightly-for-ide-on-scala-2.10.x/
{
  // Variables that may be external.  We have the defaults here.
  vars: {
    scala-version: "2.10.5-SNAPSHOT"
    scala-version: ${?SCALA_VERSION}
    publish-repo: "http://private-repo.typesafe.com/typesafe/ide-2.10"
    publish-repo: ${?PUBLISH_REPO}
  }
  build: {
    "projects":[
      {
        name:  "scala-lib",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-library;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-compiler",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-compiler;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-actors",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-actors;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "scala-reflect",
        system: "ivy",
        uri:    "ivy:org.scala-lang#scala-reflect;"${vars.scala-version}
        set-version: ${vars.scala-version}
      }, {
        name:  "specs",
        system: "ivy",
        uri:    "ivy:org.specs2#specs2_2.10;1.12.3"
        set-version: "1.12.3"
      }, {
        name:   "scalacheck",
        system: "ivy",
        uri:    "ivy:org.scalacheck#scalacheck_2.10;1.10.1"
      }, {
        name:   "sbinary",
        uri:    "git://github.com/harrah/sbinary.git#v0.4.2"
        extra: { projects: ["core"] }
      }, {
        name:   "sbt",
        uri:    "git://github.com/sbt/sbt.git#v0.13.0"
        extra: {
          projects: ["compiler-interface",
                     "classpath","logging","io","control","classfile",
                     "process","relation","interface","persist","api",
                     "compiler-integration","incremental-compiler","compile","launcher-interface"
                    ],
          run-tests: false
        }
      }, {
        name:   "sbt-republish",
        uri:    "http://github.com/typesafehub/sbt-republish.git#master",
        set-version: "0.13.0-on-"${vars.scala-version}"-for-IDE-SNAPSHOT"
      }, {
        name:   "zinc",
        uri:    "https://github.com/typesafehub/zinc.git#v0.3.0"
      }
    ],
    options:{cross-version:standard},
  }
  options: {
    deploy: [
      {
        uri=${?vars.publish-repo},
        credentials="/home/jenkinsdbuild/dbuild-josh-credentials.properties",
        projects:["sbt-republish"]
      }
    ]
    notifications: {
      send:[{
        projects: "."
        send.to: "qbranch@typesafe.com"
        when: bad
      },{ 
        projects: "."
        kind: console
        when: always
      }]
      default.send: {
        from: "jenkins-dbuild <antonio.cunei@typesafe.com>"
        smtp:{
          server: "psemail.epfl.ch"
          encryption: none
        }
      }
    }
  }
}
