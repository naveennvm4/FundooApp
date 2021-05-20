import Foundation
import FirebaseDatabase
import  UIKit

class NoteItem{
    var ref: DatabaseReference?
    var id : String
    var title: String
    var description:String
    var createdAt : Date
    
    init(snapshot: DataSnapshot,id:String ,timestamp: Double, title: String, description: String){
        ref = snapshot.ref
        self.title = title
        self.description = description
        self.id = id
//        let data = snapshot.value as! Dictionary<String , String>
//        title = data["title"]! as String
//        description = data["description"]! as String
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
