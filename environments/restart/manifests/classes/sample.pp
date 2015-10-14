class sample {

	$x = $::rotationstatus
    
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    #if $x == "Out of rotation" {

        exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        onlyif => [ "$x == 'Out of rotation'" ]
        }
    #}
}