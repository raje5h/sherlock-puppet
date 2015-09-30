class disablealerts {
	
	exec { "solr_daemon":
        command => "echo 'deb http://10.47.2.22:80/repos/alertz-nsca-wrapper/4 /' | sudo tee --append /etc/apt/sources.list.d/hudson.list",
        logoutput => true,
        path => [ "/bin/", "/usr/bin" ]
    }
}