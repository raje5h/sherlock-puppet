class sherlockclouddeploy {

    $packageVersion = $::sherlockversion
    $currentRotationStatus = $::rotationstatus

    $envVersion = "HEAD"
    $envName = "sherlock-app-solr-search-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    $repo_version = $::repoversion
    $downgrade_deb_version = $::downgradedebversion
    
    exec { "infra-cli-command":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion | sudo tee /etc/apt/sources.list.d/sherlock.list",
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
        exec { "fk-w3-sherlock":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["reinstall-ha-proxy"],
        }  
    } else {
      exec { "fk-w3-sherlock":
          command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock=$downgrade_deb_version",
          path => "/usr/bin",
          logoutput => false,
          tries => 2,
          timeout => 3000,
          require => Exec["reinstall-ha-proxy"],
        }
    }
    

    file { "/etc/default/sherlockclouddeploy-health-script.sh":
        owner => root,
        group => root,
        content => template("common/sherlockclouddeploy-health-script"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    exec { "health-check-script":
         command => "sh /etc/default/sherlockclouddeploy-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         logoutput => true,
         require => File["/etc/default/sherlockclouddeploy-health-script.sh"]
    }
}
