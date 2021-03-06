//
//  DictionaryDecoderTests.swift
//  MoreCodable
//
//  Created by Tatsuya Tanaka on 20180211.
//  Copyright © 2018年 tattn. All rights reserved.
//

import XCTest
@testable import MoreCodable

class DictionaryDecoderTests: XCTestCase {

    var decoder = DictionaryDecoder()

    override func setUp() {
        super.setUp()
        decoder = DictionaryDecoder()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDecodeSimpleModel() throws {
        struct User: Codable {
            let name: String
            let age: Int
        }

        let dictionary: [String: Any] = [
            "name": "Tatsuya Tanaka",
            "age": 24
        ]
        let user = try decoder.decode(User.self, from: dictionary)
        XCTAssertEqual(user.name, dictionary["name"] as? String)
        XCTAssertEqual(user.age, dictionary["age"] as? Int)
    }

    func testFailDecoding() {
        decoder.storage.push(container: "string"); do {
            let container = try! decoder.singleValueContainer()
            XCTAssertNil(try? container.decode(Bool.self))
        }

        struct CustomType: Decodable {
            let value: Int = 0
        }
        decoder = DictionaryDecoder()
        decoder.storage.push(container: CustomType()); do {
            let container = try! decoder.singleValueContainer()
            XCTAssertNil(try? container.decode(Bool.self))
        }
    }

    func testOptionalValues() throws {
        struct Model: Codable, Equatable {
            let int: Int?
            let string: String?
            let double: Double?
        }

        XCTAssertEqual(try decoder.decode(Model.self, from: ["int": 0, "string": "test"]), Model(int: 0, string: "test", double: nil))
        XCTAssertEqual(try decoder.decode(Model.self, from: ["double": 0.5, "string": "test"]), Model(int: nil, string: "test", double: 0.5))
    }
}
