//
//  Video.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/06.
//

import Foundation

struct Video: Codable, Hashable, Identifiable {
    var id = UUID()
    let title: String?
    let url: URL
    let durationSeconds: Float64
    let date: String
}
