class sherlocksolrdeploy {

    $solrPackageVersion = $::sherlockversion
    $solrCurrentRotationStatus = $::rotationstatus

    $solrEnvVersion = "HEAD"
    $solrEnvName = "sherlock-app-solr-only-env"
    $solr_repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $solr_repo_svc_port = "8080"
    $solr_appkey = "12"
    
    $repo_version = $::repoversion
    $downgrade_deb_version = $::downgradedebversion
    
    exec { "infra-cli-command":
        command => "reposervice --host $solr_repo_svc_host --port $solr_repo_svc_port getenv --name $solrEnvName --appkey $solr_appkey --version $solrEnvVersion | sudo tee /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => [ "/bin/", "/usr/bin/" ],
        require => Exec["infra-cli-command"],
    } 
    
    exec { "reinstall-ha-proxy":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-haproxy --reinstall",
        path => [ "/bin/", "/usr/bin/" ],
        require => Exec["apt-get-update"],
    }
    
    if($downgrade_deb_version == "FALSE") {
        exec { "fk-sherlock-solr":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-solr",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["reinstall-ha-proxy"],
        }  
    } else {
      exec { "fk-sherlock-solr":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-solr=$downgrade_deb_version",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["reinstall-ha-proxy"],
        }
    }

    file { "/etc/default/sherlocksolrdeploy-health-script.sh":
        owner => root,
        group => root,
        content => template("common/sherlocksolrdeploy-health-script"),
        mode => 777,
        require => Exec["fk-sherlock-solr"],
    }

    exec { "health-check-script":
         command => "sh /etc/default/sherlocksolrdeploy-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         logoutput => true,
         require => File["/etc/default/sherlocksolrdeploy-health-script.sh"]
    }
}
