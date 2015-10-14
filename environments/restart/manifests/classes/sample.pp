class sample {

	$x = "a"
    
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    if $currentRotationStatus == "a" {

        exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
}