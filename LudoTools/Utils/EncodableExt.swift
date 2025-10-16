//
//  EncodableExt.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: String?]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonObject as? [String: Any] else { return nil }

            return dict.mapValues { value in
                switch value {
                case let v as String: return v
                case let v as Int: return String(v)
                case let v as Double: return String(v)
                case let v as Float: return String(v)
                case let v as Bool: return v ? "true" : "false"
                case let v as Int8: return String(v)
                case let v as Int16: return String(v)
                case let v as Int32: return String(v)
                case let v as Int64: return String(v)
                case let v as UInt: return String(v)
                case let v as UInt8: return String(v)
                case let v as UInt16: return String(v)
                case let v as UInt32: return String(v)
                case let v as UInt64: return String(v)
                case let v as Date: return ISO8601DateFormatter().string(from: v)
                case let v as DayDate: return v.isoDate
                default:
                    return nil
                }
            }
        } catch {
            Logger.error("❌ Error encoding to dictionary: \(error)")
            return nil
        }
    }
}
