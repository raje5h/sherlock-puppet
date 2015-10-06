class sherlocksetup {

    $envVersion = "12"
    $envName = "sherlock-app-env"
    $alertzEnvName = "sherlock-alertz-env"
    $alertzEnvVersion = "1"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"

    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.2.22:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }

    exec { "apt-get update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }
    
    exec { "replace-db-mapping":
        command => "sudo sed -i -- 's/10.32.81.155/10.33.81.152/g' /etc/hosts",
        path => "/usr/bin/",
    }
    
    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["apt-get update"],
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
        timeout => 1800,
        require => [ Exec["apt-get-update"], Exec["replace-db-mapping"] ],
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
    }
}


