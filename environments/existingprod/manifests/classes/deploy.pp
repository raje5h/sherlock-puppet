class deploy {

    $packageVersion = hiera('version')

    exec { "apt-update":
        command => "sudo apt-get update",
        logoutput => true,
        path => "/usr/bin/",
    }

    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --force-yes install fk-w3-sherlock=$packageVersion",
        path => "/usr/bin",
        logoutput => true,
	    tries => 2,
        timeout => 600,
        require => Exec["apt-update"],
    }

    file { "/home/udit.jain/health-script.sh":
        owner => root,
        group => root,
        content => template("common/health-script.sh"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    exec { "health-check-script":
         command => "/home/udit.jain/health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         logoutput => true,
         timeout => 900,
         require => File["/home/udit.jain/health-script.sh"],
    }
}


