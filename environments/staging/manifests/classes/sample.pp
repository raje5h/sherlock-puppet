class sample {
    $foo = $::foo
    
    exec {"ap-get-update":
        command => "echo $foo",
        path => "/usr/bin/",
    }
}
