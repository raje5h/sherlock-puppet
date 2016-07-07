node /^sherlock-(app|app-cloud|internal-app-cloud).*aggregator/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        include tcpsettings
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-(app|app-cloud|internal-app-cloud|test-env).*solr-only/ {
        include commonsetup
        include solrdiskmount
        include solrapplicationsources
        include haproxy
        include solrapplicationsetup
        include cosmos
        include alertz
        include tcpsettings
        
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['solrdiskmount'] -> Class['solrapplicationsources'] ->  Class['haproxy'] -> Class['solrapplicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-(app-cloud|internal-app-cloud)/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include haproxy
        include cosmos
        include alertz
        include tcpsettings
        
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

#check this later
node /^sherlock-test-env-(preprod|perf)/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include haproxy
        include cosmos
        include alertz
        include tcpsettings
        
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-test-env-preprod-hudson/ {
        include hudsoncommonsetup
        include hudsonapplicationsources
        include hudsonapplicationsetup
        include hudsoncosmos
        include alertz
        include tcpsettings
        Class['hudsoncommonsetup'] -> Class['tcpsettings'] -> Class['hudsonapplicationsources'] -> Class['hudsonapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}