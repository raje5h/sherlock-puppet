class sample {
    $foovar = $::bar
    
    exec {"ap-get-update":
        command => "echo $foovar",
        logoutput => true,
        path => ["/bin/", "/usr/bin/"],
    }
}
