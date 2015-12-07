class common {

   file {"/etc/apt/apt.conf.d/99auth":
        owner => root,
        group => root,
        content => "APT::Get::AllowUnauthenticated yes;",
        mode => 644,
    }
}
