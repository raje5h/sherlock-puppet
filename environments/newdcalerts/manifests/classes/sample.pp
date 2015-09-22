class sample {
    
    exec { "apt-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
}


