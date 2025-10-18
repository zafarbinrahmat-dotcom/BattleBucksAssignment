//
//  PostResponseModel.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import Foundation

struct PostResponseModel: Decodable {
    let id: Int?
    let userId: Int?
    let title: String?
    let body: String?
}
