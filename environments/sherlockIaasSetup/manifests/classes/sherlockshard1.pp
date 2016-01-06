class sherlockshard1 {

   exec { "sudo-apt-get-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec[sudo-apt-get-update-2]
    }
}
