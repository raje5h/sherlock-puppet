class restart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-hudson restart",
            logoutput => true,
            path => "/usr/bin/",
        }

    exec { "bir":
            command => "sudo fk-w3-hudson-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            require => Exec["restart"],
        }
}