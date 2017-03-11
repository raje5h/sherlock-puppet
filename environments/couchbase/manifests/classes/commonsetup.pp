class commonsetup {

    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.2.22:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }
    exec { "apt-get-update-infra":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }

    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["apt-get-update-infra"],
    }

    exec { "adding-host-6":
        command => "echo '10.47.4.204    pf-config-publish.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-5"],
    }
}
