node /^sherlock-app-cloud-sherlock-aggregator/ {
        Class['commonsetup'] -> Class['applicationsources'] -> Class['haproxy'] -> Class['applicationsetup'] -> Class['cosmos'] -> Class['alertz']
}
