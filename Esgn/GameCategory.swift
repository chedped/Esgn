//
//  GameCategory.swift
//  Esgn
//
//  Created by Somsak Wongsinsakul on 12/15/17.
//  Copyright © 2017 Maya Wizard. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameCategory: NSObject {

    static let shared: GameCategory = GameCategory()
    var games: [Game] = []
    
    func parseObject( _ json: JSON ) {
        games.removeAll()
        let resultdata = json["result"].arrayValue
        for resultjson in resultdata {
            let game = Game(withJSON: resultjson)
            games.append(game)
        }
    }
    
    func game( withGameId game_id: String! ) -> Game? {
        
        for game in games {
            if game.game_id == game_id {
                return game
            }
        }
        return nil
    }
}

class Game: NSObject {
    var game_id: String!
    var name: String!
    var type: String!
    var owner: String!
    var main_web_link: String?
    var desc: String!
    var image_url: String?
    
    init( withJSON json: JSON ) {
        super.init()
        
        game_id = json["game_id"].stringValue
        name = json["name"].stringValue
        type = json["type"].stringValue
        owner = json["owner"].stringValue
        main_web_link = json["main_web_link"].string
        desc = json["description"].stringValue
        image_url = json["image_url"].string
    }
    
}
