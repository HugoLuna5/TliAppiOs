//
//  FeedData.swift
//  Tli App
//
//  Created by Hugo Luna on 1/23/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation

class FeedData{
    
    let type: String
    let uid: String
    let id_post: String
    let time: CLong
    let content: String
    
    

    
    init(typeText: String, uidText: String, id_postText: String, timeText: CLong, contentText: String) {
        
        type = typeText
        uid = uidText
        id_post = id_postText
        time = timeText
        content = contentText
        
    }
    
    
    
}
