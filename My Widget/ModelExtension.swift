//
//  ModelExtension.swift
//  My Widget
//
//  Created by mehulmac on 20/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

// MARK:
// MARK: ModelManager
class ModelManager: NSObject {
    
    static let sharedInstance = ModelManager()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    //Facility
    func getListModelArray(_ jsonParsed: [JSON]) -> [ListModel] {
        var arrModel = [ListModel]()
        for object in jsonParsed {

            let model = Mapper<ListModel>().map(JSON: object.dictionaryObject!)
            arrModel.append(model!)
        }
        return arrModel
    }
    
    func getListModel(_ dict: NSDictionary) -> ListModel {
        return Mapper<ListModel>().map(JSON: dict as! [String : Any])!
    }
    
    func getListModel(_ string: String) -> ListModel {
        return Mapper<ListModel>().map(JSONString: string)!
    }
}
class ListModel : Mappable {
    
    var strPublishedAt : String?
    var strUrl : String?
    var strQuestion : String?
    var arrChoices : [ChoiceModel]?

    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        strPublishedAt <- map["published_at"]
        strUrl <- map["url"]
        strQuestion <- map["question"]
        arrChoices <- map["choices"]
    }
}

class ChoiceModel : Mappable {
    
    var strUrl : String?
    var strVotes : String?
    var strChoices : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        strUrl <- map["url"]
        strVotes <- map["votes"]
        strChoices <- map["choice"]
    }
}

