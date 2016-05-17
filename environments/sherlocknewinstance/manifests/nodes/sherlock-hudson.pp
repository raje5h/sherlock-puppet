node /^sherlock-internal-app-cloud-hudson/ {
        include hudsoncommonsetup
        include hudsonapplicationsources
        include hudsonapplicationsetup
        include hudsoncosmos
        include alertz
        
        Class['hudsoncommonsetup'] -> Class['hudsonapplicationsources'] -> Class['hudsonapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}
