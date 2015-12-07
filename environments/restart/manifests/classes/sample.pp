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
        #onlyif => 'test "$flag == 1"'
        }

    }

	if ($x == "Out of rotation") {
    	
        exec { "apt-update-3":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["apt-update-2"]
        }

	}

    else {

        exec { "apt-update-4":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["apt-update-1"]
        }
    }


}