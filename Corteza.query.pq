// Use this file to write queries to test your data connector
let
    
    result = Corteza.Contents("http://cterp.autokeen.com.my/auth/oauth2/token", "http://cterp.autokeen.com.my/api", "294998811741257731", "297776173146963971")
in
    result