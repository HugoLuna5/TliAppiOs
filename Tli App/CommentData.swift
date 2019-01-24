//
//  CommentData.swift
//  Tli App
//
//  Created by Hugo Luna on 1/23/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation


class CommentData {
    
    let uid: String
    let id_comment: String
    let comment: String
    
    
    init(uidText: String, id_commentText: String, commentText: String){
        uid = uidText
        id_comment = id_commentText
        comment = commentText
    }
}
