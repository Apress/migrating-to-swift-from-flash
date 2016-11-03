//
//  Choice.swift
//  SimpleVote
//
//  Created by Radoslava Leseva on 10/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import Foundation

struct Choice
{
    let title: String
    var votes: Int = 0
    
    init(title: String)
    {
        self.title = title
    }
}