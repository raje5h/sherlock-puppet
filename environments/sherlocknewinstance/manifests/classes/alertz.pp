class alertz {
  
    $envVersion = "1"
    $envName = "sherlock-alertz-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    exec { "alertz-sources-list":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock-alertz.list",
        path => "/usr/bin/",
    }
    
    exec { "apt-get update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        logoutput => true,
        require => Exec["alertz-sources-list"],
    }

    exec { "apt-get install fk-nsca-wrapper":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-nsca-wrapper",
        path => "/usr/bin/",
        logoutput => true,
        require => Exec["apt-get update"],
    }

    exec { "apt-get install fk-nagios-common":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-nagios-common",
        path => "/usr/bin/",
        logoutput => true,
        require => Exec["apt-get install fk-nsca-wrapper"],
    }

    exec { "truncate nsca_wrapper":
        command => "sudo truncate --size=0 /etc/default/nsca_wrapper",
        path => "/usr/bin/",
        logoutput => true,
        require => Exec["apt-get install fk-nagios-common"],
    }

    exec { "Setting team_name=sherlock":
        command => "echo 'team_name=\"sherlock\"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => [ "/bin/", "/usr/bin" ] ,
        logoutput => true,
        require => Exec["truncate nsca_wrapper"],
    }

    exec { "Setting nagios_server_ip=10.47.2.198":
        command => "echo 'nagios_server_ip=\"10.47.2.198\"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => [ "/bin/", "/usr/bin" ] ,
        logoutput => true,
        require => Exec["Setting team_name=sherlock"],
    }

    exec { "kill dpkg":
        command => "echo `ps -ef | grep dpkg | grep -v grep | awk '{print $2}'` | sudo kill -9 --",
        path => [ "/bin/", "/usr/bin" ] ,
        logoutput => true,
        require => Exec["Setting nagios_server_ip=10.47.2.198"],
    }

    exec { "apt-get install fk-ops-sgp-sherlock":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock",
        path => "/usr/bin/",
        logoutput => true,
        require => Exec["kill dpkg"],
    }
}
