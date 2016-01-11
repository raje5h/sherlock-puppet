class sample {
    $foo = $::foo
    
    exec {"ap-get-update":
        command => "echo $foo 234",
        logoutput => true,
        path => ["/bin/", "/usr/bin/"],
    }
}
