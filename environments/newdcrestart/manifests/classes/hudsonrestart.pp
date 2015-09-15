class hudsonrestart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-hudson restart",
            logoutput => true,
            path => "/usr/bin/",
        }

    exec { "bir":
            command => "sudo fk-w3-hudson-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            tries => 2,
            try_sleep => 10,
            require => Exec["restart"],
        }
}