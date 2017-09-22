//
//  TestService.swift
//  DemoTodayWidget
//
//  Created by mehulmac on 19/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import Foundation
import SwiftyJSON

open class APIService {
    
    enum listOfApi : String {
        case
        questions
    }
    
    func getQuestions(_ success:@escaping (_ responseObject:JSON) -> Void , failure:@escaping (_ errorResponse:JSON?) -> Void) {
        
        // create post request
        NetworkManagerExtension().Get(listOfApi.questions.rawValue,
                             paramaters: nil,
                             success: { responseObject in
                                success(responseObject)
        }) { error in
            failure(error)
        }
    }
}

