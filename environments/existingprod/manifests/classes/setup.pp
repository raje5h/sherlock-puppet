class setup {
  
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/"
    }
}

