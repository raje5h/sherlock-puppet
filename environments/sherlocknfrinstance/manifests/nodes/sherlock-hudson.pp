node /^sherlock-gamma-hudson/ {
        include hudsoncommonsetup
        include hudsonapplicationsources
        include hudsonapplicationsetup
        include hudsoncosmos
        include alertz
        
        Class['hudsoncommonsetup'] -> Class['hudsonapplicationsources'] -> Class['hudsonapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}


node /^hudson-app-hooper/ {
        include hudsoncommonsetup
        include hooperapplicationsources
        include hooperapplicationsetup
        include hudsoncosmos
        include alertz
        
        Class['hudsoncommonsetup'] -> Class['hooperapplicationsources'] -> Class['hooperapplicationsetup'] -> Class['hudsoncosmos'] -> Class['alertz']
}
