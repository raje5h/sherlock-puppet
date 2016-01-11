class sample {
    $foovar = $::foo
    
    exec {"ap-get-update":
        command => "echo $foovar",
        logoutput => true,
        path => ["/bin/", "/usr/bin/"],
    }
}
