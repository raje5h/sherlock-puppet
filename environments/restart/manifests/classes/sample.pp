class sample {

	$x = $::rotationstatus
    
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    if ($x == "Out of rotation") {

        exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        }

    exec { "apt-update-3":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["apt-update-2"]
    }

    }
}