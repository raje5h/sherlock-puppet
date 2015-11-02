class freshsherlocksetup {

    $envVersion = "12"
    $envName = "sherlock-app-env"
    
    $alertzEnvName = "sherlock-alertz-env"
    $alertzEnvVersion = "1"
    
    $cosmosEnvVersion = "1"
    $cosmosEnvName = "sherlock-cosmos-env"

    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"

    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.2.22:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }

    exec { "apt-get-update-infra":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }
    
    exec { "update-cluster-name":
        command => "sudo echo 'sherlock-books-newdc' > /etc/default/cluster-name",
        path => "/usr/bin/",
        require => Exec["apt-get-update-infra"],
    }
    
    exec { "add-db-mapping":
        command => "echo -e '10.65.30.211 pf-config-publish-alt.nm.flipkart.com\n10.65.100.54 ops-statsd.nm.flipkart.com\n10.65.38.79 pf-config-manage.nm.flipkart.com\n10.33.81.152 sherlock-app-slave-db.nm.flipkart.com\n10.33.81.152 sherlock-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => "/usr/bin/",
        require => Exec["update-cluster-name"],
    }
    
    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["add-db-mapping"],
    }

    exec { "sherlock-source":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
        require => Exec["infra-cli-install"],
    }
    
    exec { "apt-get-update-sherlock":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["sherlock-source"],
    }
    
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock",
        path => "/usr/bin",
        logoutput => false,
        tries => 2,
        timeout => 1800,
        require => [ Exec["apt-get-update-sherlock"], Exec["add-db-mapping"], Exec["update-cluster-name"] ],
    }

    file { "/etc/default/sherlocksetup-health-script.sh":
        owner => root,
        group => root,
        content => template("common/sherlocksetup-health-script"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    exec { "health-check-script":
         command => "sh /etc/default/sherlocksetup-health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         tries => 2,
         logoutput => true,
         require => File["/etc/default/sherlocksetup-health-script.sh"]
    }    
    
    exec { "alertz-source":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $alertzEnvName --appkey $appkey --version $alertzEnvVersion > /etc/apt/sources.list.d/alertz.list",
        path => "/usr/bin/",
        require => Exec["infra-cli-install"],
    }
    
    exec { "apt-get-update-alertz":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["alertz-source"],
    }

    exec { "apt-get install fk-nsca-wrapper":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-nsca-wrapper",
        path => "/usr/bin/",
        require => Exec["apt-get-update-alertz"],
    }

    exec { "apt-get install fk-nagios-common":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-nagios-common",
        path => "/usr/bin/",
        require => Exec["apt-get install fk-nsca-wrapper"],
    }

    exec { "truncate nsca_wrapper":
        command => "sudo truncate --size=0 /etc/default/nsca_wrapper",
        path => "/usr/bin/",
        require => Exec["apt-get install fk-nagios-common"],
    }

    exec { "Setting team_name=sherlock":
        command => "echo 'team_name=\"sherlock\"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["truncate nsca_wrapper"],
    }

    exec { "Setting nagios_server_ip=10.47.2.198":
        command => "echo 'nagios_server_ip=\"10.47.2.198\"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["Setting team_name=sherlock"],
    }

    exec { "kill dpkg":
        command => "echo `ps -ef | grep dpkg | grep -v grep | awk '{print $2}'` | sudo kill -9 --",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["Setting nagios_server_ip=10.47.2.198"],
    }

    exec { "apt-get install fk-ops-sgp-sherlock":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock",
        path => "/usr/bin/",
        require => Exec["kill dpkg"],
    }
    
    exec { "cosmos sources list":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $cosmosEnvName --appkey $appkey --version $cosmosEnvVersion > /etc/apt/sources.list.d/sherlock-cosmos.list",
        path => "/usr/bin/",
        require => Exec["fk-w3-sherlock"]
    }

    exec { "cosmos-service=sherlock-app":
        command => "sudo echo 'sherlock-app' > /etc/default/cosmos-service",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos sources list"],
    }

    exec { "sudo apt-get update cosmos":
        command => "sudo apt-get update ",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-service=sherlock-app"],
    }

    exec { "fk-ops-sgp-sherlock install":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["sudo apt-get update cosmos"],
    }

    exec { "fk-config-service-confd":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-config-service-confd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["fk-ops-sgp-sherlock install"],
    }

    exec { "stream-relay":
        command => "sudo apt-get install --yes --allow-unauthenticated stream-relay --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["fk-config-service-confd"],
    }

    exec { "cosmos-collectd":
        command => "sudo apt-get -o Dpkg::Options::='--force-confdef' install --yes --allow-unauthenticated cosmos-collectd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["stream-relay"],
    }

    exec { "cosmos-tail":
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-tail --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-collectd"],
    }

    exec { "cosmos-jmx install":
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-jmx --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-tail"],
    }

    exec { "cosmos-statsd":
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-statsd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-jmx install"],
    }

    exec { "cosmos-jmx restart":
        command => "sudo /etc/init.d/cosmos-jmx restart",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-statsd"],
    }

    exec { "fk-ops-sgp-sherlock reinstall":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-jmx restart"],
    }
}