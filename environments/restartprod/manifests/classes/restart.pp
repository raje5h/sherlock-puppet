class restart {

    $currentRotationStatus = $::rotationstatus

    exec { "stop":
            command => "sudo /etc/init.d/fk-w3-sherlock stop",
            logoutput => true,
            path => "/usr/bin/",
        }

    exec { "start":
            command => "sudo /etc/init.d/fk-w3-sherlock start",
            logoutput => true,
            path => "/usr/bin/",
            require => Exec["stop"],
        }

    if $currentRotationStatus == "In rotation" {

        exec { "admin-bir":
            command => "sudo fk-w3-sherlock-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            #onlyif => [$currentRotationStatus == "In rotation"]
            require => Exec["start"],
        }
    }
}