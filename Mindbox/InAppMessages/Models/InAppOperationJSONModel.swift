//
//  InAppOperationJSONModel.swift
//  Mindbox
//
//  Created by Akylbek Utekeshev on 16.03.2023.
//  Copyright © 2023 Mindbox. All rights reserved.
//

import Foundation

struct InappOperationJSONModel: Codable, Equatable, Hashable {
    let viewProduct: ViewProduct?
    let viewProductCategory: ViewProductCategory?

    static func == (lhs: InappOperationJSONModel, rhs: InappOperationJSONModel) -> Bool {
        lhs.viewProductCategory == rhs.viewProductCategory && lhs.viewProduct == rhs.viewProduct
    }

    init(viewProduct: ViewProduct? = nil, viewProductCategory: ViewProductCategory? = nil) {
        self.viewProduct = viewProduct
        self.viewProductCategory = viewProductCategory
    }
}

struct ViewProduct: Codable, Equatable, Hashable {
    let product: ProductCategory

    static func == (lhs: ViewProduct, rhs: ViewProduct) -> Bool {
        lhs.product == rhs.product
    }
}

struct ViewProductCategory: Codable, Equatable, Hashable {
    let productCategory: ProductCategory

    static func == (lhs: ViewProductCategory, rhs: ViewProductCategory) -> Bool {
        lhs.productCategory == rhs.productCategory
    }
}

struct ProductCategory: Codable, Equatable, Hashable {
    let ids: [String: String]

    enum CodingKeys: String, CodingKey {
        case ids
    }

    init(ids: [String: String]) {
        self.ids = ids
    }
}
