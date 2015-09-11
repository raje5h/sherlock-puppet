class set_alerts {
    
    exec { "Appending deb alertz-nsca-wrapper":
        command => "echo 'deb http://10.47.2.22:80/repos/alertz-nsca-wrapper/4 /‘ | sudo tee --append /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
    }

    exec { "Appending deb alertz-nagios-common":
        command => "echo 'deb http://10.47.2.22:80/repos/alertz-nagios-common/5 /' | sudo tee --append /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
        require => Exec["Appending deb alertz-nsca-wrapper"],
    }

    exec { "Appending deb fk-ops-sgp-sherlock":
        command => "echo 'deb http://10.47.2.22:80/repos/fk-ops-sgp-sherlock/9 /' | sudo tee --append /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
        require => Exec["Appending deb alertz-nagios-common"],
    }

    exec { "apt-get update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["Appending deb fk-ops-sgp-sherlock"],
    }

    exec { "apt-get install fk-nsca-wrapper":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-nsca-wrapper",
        path => "/usr/bin/",
        require => Exec["apt-get update"],
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
        command => "echo 'team_name="sherlock"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => "/usr/bin/",
        require => Exec["truncate nsca_wrapper"],
    }

    exec { "Setting nagios_server_ip=10.47.2.198":
        command => "echo 'nagios_server_ip="10.47.2.198"'  | sudo tee --append /etc/default/nsca_wrapper",
        path => "/usr/bin/",
        require => Exec["Setting team_name=sherlock"],
    }

    exec { "kill dpkg":
        command => "echo `ps -ef | grep dpkg | grep -v grep | awk '{print $2}'` | sudo kill -9 ",
        path => "/usr/bin/",
        require => Exec["Setting nagios_server_ip=10.47.2.198],
    }

    exec { "apt-get install fk-ops-sgp-sherlock":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-ops-sgp-sherlock",
        path => "/usr/bin/",
        require => Exec["kill dpkg"],
    }


}


