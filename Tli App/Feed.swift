//
//  Feed.swift
//  Tli App
//
//  Created by Hugo Luna on 1/24/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation


class Feed{
    
    let id_post: String
    let time: CLong
    let content: String
    let uid: String
    let type: String
    
    init(id_postText: String, timeLong: CLong, contentText: String, uidText: String, typeText: String) {
        
        id_post = id_postText
        time = timeLong
        content = contentText
        uid = uidText
        type = typeText
        
    }
    
    
    
}
