class sample-health{

    $Version = "1.1434364148-01nm"
    $env = "9"

    exec {"health-check-script":
         command => "sh /home/udit.jain/health-script.sh",
         path => "/bin/",
    }
}


