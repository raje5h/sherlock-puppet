node /^sherlock-gamma.*aggregator/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        include tcpsettings
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-gamma.*semantic-service/ {
        include commonsetup
        include sherlockdiskmount
        include applicationsources
        include applicationsetup
        include cosmos
        include alertz
        include tcpsettings
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['sherlockdiskmount'] -> Class['applicationsources'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-gamma.*solr-only/ {
        include commonsetup
        include solrdiskmount
        include solrapplicationsources
        include solrapplicationsetup
        include cosmos
        include alertz
        include tcpsettings
        
        Class['commonsetup'] -> Class['tcpsettings'] -> Class['solrdiskmount'] -> Class['solrapplicationsources'] -> Class['solrapplicationsetup'] -> Class['cosmos'] -> Class['alertz']
}

node /^sherlock-gamma/ {
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
