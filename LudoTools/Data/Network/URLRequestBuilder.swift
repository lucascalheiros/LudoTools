//
//  URLRequestBuilder.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import Foundation

protocol URLRequestBuilder {
    func createRequest(_ apiEntry: ApiEntry) -> URLRequest
}
