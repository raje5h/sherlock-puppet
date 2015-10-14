class sample {

	$x = $::rotationstatus
    
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    if ($x == "In rotation") {

        exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        }

    }

    file { "/etc/default/restart-health-script.sh":
            owner => root,
            group => root,
            content => template("common/hudsonrestart-health-script"),
            mode => 777,
            require => Exec["apt-update-2"],
    }
}