//
//  LudopediaApiConfig.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

struct LudopediaApiConfig {
    let baseUrl = "https://ludopedia.com.br"
    let appId = "732fdcaa19859515"
    let appKey = "bcda73596a57cdda6ff5456feed3404f"
}

@propertyWrapper
struct LudopediaApiConfigWrapper {

    var value = LudopediaApiConfig()
    var wrappedValue: LudopediaApiConfig {
        get { value }
        set { value = newValue }
    }
}
