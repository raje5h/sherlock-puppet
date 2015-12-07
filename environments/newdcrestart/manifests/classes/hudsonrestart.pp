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

    file { "/home/vishal.goel/health-script.sh":
        owner => root,
        group => root,
        content => template("common/hudsonrestart-health-script"),
        mode => 777,
        require => Exec["bir"],
    }

    exec { "health-check-script":
        command => "sh /home/vishal.goel/health-script.sh",
        path => [ "/bin/", "/usr/bin/" ],
        logoutput => true,
        timeout => 500,
        require => File["/home/vishal.goel/health-script.sh"],
    }
}