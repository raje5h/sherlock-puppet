class sample {

	$x = $::rotationstatus
    $flag = 0
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    #if ($x == "In rotation") {

    	#$flag = 1
        exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        onlyif => 'test "$flag == 1"'
        }

    #}

	#if ($flag == 1) {
    	exec { "apt-update-3":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["apt-update-2"]
        }
	#}
}