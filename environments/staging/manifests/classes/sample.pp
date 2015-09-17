class sample {
    
    exec {"apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
}