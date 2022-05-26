//
//  ErrorCode.swift
//  AirConditionerErrorCode
//
//  Created by Yoshiyuki Karikome on 2022/05/23.
//

import RealmSwift

class ErrorCode: Object {
    @objc dynamic var id = 0
    //エラーコード
    @objc dynamic var errorCode = ""
    //製造者
    @objc dynamic var manifacturer = ""
    //室外機・室内機
    @objc dynamic var unit = ""
    //説明
    @objc dynamic var discription = ""
    //主な原因
    @objc dynamic var cause = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
