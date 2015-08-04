class deploy {

    $packageVersion = hiera('version')
    $currentRotationStatus = $::rotationstatus

    exec { "admin-status":
       command => "sudo fk-w3-sherlock-admin status",
       logoutput => true,
       path => "/usr/bin/",
    }

    //$output = generate("/usr/bin/sudo fk-w3-sherlock-admin status");

    /*if $currentRotationStatus == "In rotation" {

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

        exec { "admin-bir":
            command => "sudo fk-w3-sherlock-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            require => Exec["start"],
        }
    }*/
}