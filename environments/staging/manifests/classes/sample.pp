class sample {

    exec {"ap-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
}
