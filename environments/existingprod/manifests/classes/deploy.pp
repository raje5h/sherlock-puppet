class deploy {

    $packageVersion = hiera('version')
    $currentRotationStatus = $::rotationstatus

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

    exec { "check-fact":
        command => "echo $newversion",
        path => ["/bin/", "/usr/bin" ],
        require => Exec["fk-w3-sherlock"],
    }

    file { "/home/udit.jain/health-script.sh":
        owner => root,
        group => root,
        content => template("common/health-script"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    exec { "health-check-script":
        command => "sh /home/udit.jain/health-script.sh",
        path => [ "/bin/", "/usr/bin/" ],
        logoutput => true,
        timeout => 900,
        require => File["/home/udit.jain/health-script.sh"],
    }
}

