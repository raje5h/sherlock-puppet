class sherlocksolrdeploy {

    $solrPackageVersion = $::solrversion
    $solrCurrentRotationStatus = $::solrrotationstatus

    $solrEnvVersion = "HEAD"
    $solrEnvName = "sherlock-app-solr-only-env"
    $solr_repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $solr_repo_svc_port = "8080"
    $solr_appkey = "12"
    
    $solr_repo_version = $::repoversion
    $solr_downgrade_deb_version = $::downgradedebversion
    
    exec { "solr-infra-cli-command":
        command => "reposervice --host $solr_repo_svc_host --port $solr_repo_svc_port getenv --name $solrEnvName --appkey $solr_appkey --version $solrEnvVersion | sudo tee /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
    }
    
    exec { "solr-apt-get-update":
        command => "sudo apt-get update",
        path => [ "/bin/", "/usr/bin/" ],
        require => Exec["solr-infra-cli-command"],
    } 
    
    exec { "solr-reinstall-ha-proxy":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-haproxy --reinstall -t wheezy-backports",
        path => [ "/bin/", "/usr/bin/" ],
        require => Exec["solr-apt-get-update"],
    }
    
    if($solr_downgrade_deb_version == "FALSE") {
        exec { "solr-fk-sherlock-solr":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-solr",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["solr-reinstall-ha-proxy"],
        }  
    } else {
      exec { "solr-fk-sherlock-solr":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-solr=$solr_downgrade_deb_version",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["solr-reinstall-ha-proxy"],
        }
    }

    file { "/etc/default/sherlocksolrdeploy-health-script.sh":
        owner => root,
        group => root,
        content => template("common/sherlocksolrdeploy-health-script"),
        mode => 777,
        require => Exec["solr-fk-sherlock-solr"],
    }

    exec { "solr-health-check-script":
         command => "sh /etc/default/sherlocksolrdeploy-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         logoutput => true,
         require => File["/etc/default/sherlocksolrdeploy-health-script.sh"]
    }
}
