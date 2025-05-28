//
//  IssueSubmissionRowModel.swift
//  Creator
//
//  Created by Jaffer Sheriff U on 21/11/23.
//  Copyright © 2023 Zoho. All rights reserved.
//

import Foundation

struct IssueSubmissionRowModel{
    let type: IssueSubmissionRowType
    let displayName: String
    let placeHolder: String
    let isMandatory: Bool
}

enum IssueSubmissionRowType{
    case email, video, subject, ticketId, description, addToExistingTicket, fileAttachment
}
