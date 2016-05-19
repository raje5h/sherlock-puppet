node /^sherlock-(app-cloud|internal-app-cloud)-sherlock-aggregator/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-(app-cloud|internal-app-cloud)-sherlock-solr/ {
        include commonsetup
        include solrdiskmount
        include solrapplicationsources
        include solrapplicationsetup
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['solrdiskmount'] -> Class['solrapplicationsources'] -> Class['solrapplicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-(app-cloud|internal-app-cloud)/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include haproxy
        include cosmos
        include alertz
        
        Class['commonsetup'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
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
        
        Class['commonsetup'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] ->  Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-test-env-preprod-hudson/ {
        include hudsoncommonsetup
        include hudsonapplicationsources
        include hudsonapplicationsetup
        include hudsoncosmos
        include alertz
        
        Class['hudsoncommonsetup'] -> Class['hudsonapplicationsources'] -> Class['hudsonapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}