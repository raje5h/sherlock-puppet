class hudsondeploy {

    $currentRotationStatus = $::hudsonrotationstatus
    $inRotation = "In Rotation"

    $envVersion = "8"
    $envName = "hudson-app-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"

    exec { "infra-cli-command":
    	command => "sudo su - && reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/hudson.list",
	    path => "/usr/bin/",
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	    require => Exec["infra-cli-command"],
    }
    
    exec { "fk-w3-hudson":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-hudson",
        path => "/usr/bin",
        logoutput => false,
	    tries => 2,
        timeout => 300,
        require => Exec["apt-get-update"],
    }

    file { "/etc/default/hudsondeploy-health-script.sh":
        owner => root,
        group => root,
        content => template("common/hudsondeploy-health-script"),
        mode => 777,
        require => Exec["fk-w3-hudson"],
    }

    exec { "health-check-script":
         command => "sh /etc/default/hudsondeploy-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         try_sleep => 5,
         logoutput => true,
         require => File["/etc/default/hudsondeploy-health-script.sh"]
    }
}


