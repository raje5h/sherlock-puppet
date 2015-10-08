class hudsonrestart {

    $currentRotationStatus = $::hudsonrotationstatus
     
      exec { "restart":
            command => "sudo /etc/init.d/fk-w3-hudson restart",
            logoutput => true,
            path => "/usr/bin/",
        }    
    
       
       exec { "bring-in-rotation":
            command => "sudo fk-w3-hudson-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            tries => 3,
            try_sleep => 10,
            require => Exec["restart"],
        }
   

      file { "/etc/default/restart-health-script.sh":
            owner => root,
            group => root,
            content => template("common/hudsonrestart-health-script"),
            mode => 777,
            require => Exec["bring-in-rotation"],
      }

      exec { "health-check-script":
            command => "sh /etc/default/restart-health-script.sh",
            path => [ "/bin/", "/usr/bin/" ],
            logoutput => true,
            timeout => 500,
            require => File["/etc/default/restart-health-script.sh"],
      }
}
