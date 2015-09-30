class disablealerts {
	
	exec { "solr_daemon":
        command => "sudo svc -d /etc/service/solr_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
    }

    exec { "nagios_CheckInodeUsage_daemon":
        command => "sudo svc -d /etc/service/nagios_CheckInodeUsage_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["solr_daemon"],
    }

    exec { "CheckSwapUsage_daemon":
        command => "sudo svc -d /etc/service/nagios_CheckSwapUsage_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["nagios_CheckInodeUsage_daemon"],
    }

    exec { "CheckLoad_daemon":
        command => "sudo svc -d /etc/service/nagios_CheckLoad_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["CheckSwapUsage_daemon"],
    }

    exec { "CheckMemory_daemon":
        command => "sudo svc -d /etc/service/nagios_CheckMemory_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["CheckLoad_daemon"],
    }

    exec { "search_rotation":
        command => "sudo svc -d /etc/service/search_rotation",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["CheckMemory_daemon"],
    }

    exec { "search_rotation_daemon":
        command => "sudo svc -d /etc/service/search_rotation_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["search_rotation"],
    }

    exec { "log_growth_daemon":
        command => "sudo svc -d /etc/service/log_growth_daemon",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
        require => Exec["search_rotation_daemon"],
    }
}