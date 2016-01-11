class sample {
    $foovar = $::hostname
    
    exec {"ap-get-update":
        command => "echo $foovar",
        logoutput => true,
        path => ["/bin/", "/usr/bin/"],
    }
}
