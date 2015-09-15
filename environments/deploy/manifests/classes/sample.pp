class sample {
    
    exec {"apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	require => File["/etc/apt/sources.list.d/source1.list"],
    }
}


