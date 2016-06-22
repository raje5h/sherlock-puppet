class etchostrefresh {
  
  $dpIp = $::db_entry
  
  exec { "removing-host-1":
        command => "sed -i '/.*pf-config-publish-alt.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
    }
    
    exec { "removing-host-2":
        command => "sed -i '/.*pf-config-manage.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-1"],
    }
    
    exec { "removing-host-3":
        command => "sed -i '/.*10.65.100.54   ops-statsd.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-2"],
    }
    
    exec { "removing-host-4":
        command => "sed -i '$dpIp   sherlock-app-slave-db.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-3"],
    }
    
    exec { "removing-host-5":
        command => "sed -i '/.*sherlock-slave-db.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-4"],
    }
    
    exec { "removing-host-6":
        command => "sed -i '/.*pf-config-publish.nm.flipkart.com.*/d' /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-5"]
    }
    
   exec { "adding-host-1":
        command => "echo '10.65.30.211  pf-config-publish-alt.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["removing-host-6"],
    }
    
    exec { "adding-host-2":
        command => "echo '10.65.38.79   pf-config-manage.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-1"],
    }
    
    exec { "adding-host-3":
        command => "echo '10.65.100.54   ops-statsd.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-2"],
    }
    
    exec { "adding-host-4":
        command => "echo '$dpIp   sherlock-app-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-3"],
    }
    
    exec { "adding-host-5":
        command => "echo '$dpIp    sherlock-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-4"],
    }
    
    exec { "adding-host-6":
        command => "echo '10.84.35.1    pf-config-publish.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-5"]
    }   
}