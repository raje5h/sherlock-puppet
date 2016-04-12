node /^sherlock-(app-cloud|internal-app-cloud)-sherlock-aggregator/ {
        include commonsetup
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-(app-cloud|internal-app-cloud)/ {
        include commonsetup
        include applicationsources
        include applicationsetup
        include haproxy
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-test-env-preprod-sherlock/ {
        include commonsetup
        include applicationsources
        include applicationsetup
        include haproxy
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-test-env-preprod-hudson/ {
        include hudsoncommonsetup
        include hudsonapplicationsources
        include hudsonapplicationsetup
        include hudsoncosmos
        include alertz
        
        Class['hudsoncommonsetup'] -> Class['hudsonapplicationsources'] -> Class['hudsonapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}