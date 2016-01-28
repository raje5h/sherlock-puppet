class sherlockclouddeploy {

    $packageVersion = $::sherlockversion
    $currentRotationStatus = $::rotationstatus

    $envVersion = "3"
    $envName = "sherlock-app-solr-search-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    

    exec { "tcp-1":
        command => "echo 'net.core.wmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
    }
    
    exec { "tcp-2":
        command => "echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-1"],
    }
    
    exec { "tcp-3":
        command => "echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-2"],
    }
    
    exec { "tcp-4":
        command => "echo 'net.core.netdev_max_backlog = 3000'  | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-3"],
    }
    
    exec { "tcp-5":
        command => "echo 'net.core.wmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-4"],
    }
    exec { "tcp-6":
        command => "echo 'net.core.wmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-5"],
    }
    exec { "tcp-7":
        command => "echo 'net.core.rmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-6"],
    }
    
    exec { "tcp-8":
        command => "sudo sysctl --system",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-7"],
    }
    
    exec { "infra-cli-command":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
        require => Exec["tcp-8"],
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
