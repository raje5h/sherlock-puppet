class sample {
    $foovar = $::bar
    $bucket = $::configbucket
    
    exec { "test-facter":
        command => "echo $bucket",
        path => "/usr/bin/"
    }
    
    exec {"ap-get-update":
        command => "echo $foovar",
        logoutput => true,
        path => ["/bin/", "/usr/bin/"],
    }
}
