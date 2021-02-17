//
//  Country.swift
//  CountriesListApp
//
//

import Foundation

struct Country {
    
    let name: String?
    let capital: String?
    let region: String?
    
    init(item: [String: Any]) {
        name = item["name"] as? String
        capital = item["capital"] as? String
        region = item["region"] as? String
    }

    
    static func getArray(from arrayOfItems: Any) -> [Country]? {
        guard let arrayOfItems = arrayOfItems as? Array<[String: Any]> else { return nil }
        return arrayOfItems.compactMap { Country(item: $0) }
    }
}//End
