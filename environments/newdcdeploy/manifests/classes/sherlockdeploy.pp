class sherlockdeploy {

    $packageVersion = $::sherlockversion
    $currentRotationStatus = $::rotationstatus

    $envVersion = "31"
    $envName = "sherlock-app-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.4.220:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }

    exec { "apt-get-update-infra":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }
    
    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["apt-get-update-infra"],
    }
    
    exec { "infra-cli-command":
    	  command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock.list",
	      path => "/usr/bin/",
	      require => Exec["infra-cli-install"],
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	      require => Exec["infra-cli-command"],
    }
    
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock",
        path => "/usr/bin",
        logoutput => false,
	      tries => 2,
        timeout => 3000,
        require => Exec["apt-get-update"],
    }

    file { "/etc/default/sherlockdeploy-health-script.sh":
        owner => root,
        group => root,
        content => template("common/sherlockdeploy-health-script"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    exec { "health-check-script":
         command => "sh /etc/default/sherlockdeploy-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         logoutput => true,
         require => File["/etc/default/sherlockdeploy-health-script.sh"]
    }
}
