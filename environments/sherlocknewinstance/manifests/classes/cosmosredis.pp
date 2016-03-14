class cosmosredis {
  
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact

    exec { "cosmos-service-solr-app":
        command => "sudo echo '$cluster_fact' > /etc/default/cosmos-service",
        path => [ "/bin/", "/usr/bin" ] ,
    }

    exec { "update-role":
        command => "sudo echo '$cluster_fact' > /etc/default/cosmos-role",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-service-solr-app"],
    }

    exec { "fk-config-service-confd":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-config-service-confd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["update-role"],
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

    exec { "cosmos-jmx-install":
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-jmx --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-collectd"],
    }

    exec { "cosmos-statsd":
        command => "sudo apt-get install --yes --allow-unauthenticated cosmos-statsd  --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-jmx-install"],
    }

    exec { "cosmos-jmx-restart":
        command => "sudo /etc/init.d/cosmos-jmx restart",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-statsd"],
    }

    exec { "fk-ops-sgp-sherlock-reinstall":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock --reinstall",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["cosmos-jmx-restart"],
    }
}
