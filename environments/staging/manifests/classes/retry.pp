class retry{
   exec {"apt-update-2":
        command => "sudo apt-gei update",
        path => "/usr/bin/",
	tries => 3,
        try_sleep => 1, 
   }


}
