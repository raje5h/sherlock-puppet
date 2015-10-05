class hudsonsetcosmos {

    $envVersion = "1"
    $envName = "sherlock-cosmos-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"

    exec { "cosmos sources list":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/hudson-cosmos.list",
        path => "/usr/bin/",
    }

    exec { "cosmos-service=hudson-app":
        command => "sudo echo 'hudson-app' > /etc/default/cosmos-service",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos sources list"],
    }

    exec { "sudo apt-get update":
        command => "sudo apt-get update ",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-service=hudson-app"],
    }

    exec { "fk-ops-sgp-sherlock install":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["sudo apt-get update"],
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
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-collectd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        logoutput => true,
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
