class hudsondeploy {

    $currentRotationStatus = $::hudsonrotationstatus
    $inRotation = "In Rotation"

    $envVersion = "9"
    $envName = "sherlock-hudson-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    exec { "set-fd-limits":
        command => "sudo /usr/local/sbin/fk-ulimit.sh -n 500000 ",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
    exec { "java":
        command => "sudo apt-get install --yes --allow-unauthenticated oracle-j2sdk1.8",
        path => "/usr/bin",
        require => [Exec["apt-get-update"], Exec["set-fd-limits"]],
    }
    
    exec { "fk-w3-hudson":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-hudson",
        path => "/usr/bin",
        logoutput => false,
        tries => 2,
        timeout => 300,
        require => Exec["java"],
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

