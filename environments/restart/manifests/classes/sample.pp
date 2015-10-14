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
        onlyif => 'test "$flag == 0"'
        }

    #}

	#if ($flag == 1) {
    	file { "/etc/default/restart-health-script.sh":
            owner => root,
            group => root,
            content => template("common/hudsonrestart-health-script"),
            mode => 777,
            require => Exec["apt-update-2"],
    	}
	#}
}