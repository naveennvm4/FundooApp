import Foundation
import Firebase

class NoteRealtimeDatabase{
    
    static var instance:NoteRealtimeDatabase?
    var user: User!
    var notes = [NoteItem]()
    var deleteNote = [NoteItem]()
    var archiveNote = [NoteItem]()
    var ref : DatabaseReference!
    private var databasehandle: DatabaseHandle!
    private init(){
        user = Auth.auth().currentUser
        ref = Database.database().reference()
    }
    
    static func getInstance() -> NoteRealtimeDatabase{
        if instance == nil {
            instance = NoteRealtimeDatabase()
        }
        return instance!
    }
    
    func createNote(title: String , description: String){
        self.ref.child("users").child(self.user.uid).child("notes").childByAutoId().setValue(NoteDataModel.addTask(title: title , description: description))
    }
    
    func updateNote(title: String , description: String, key:String ){
        self.ref.child("users").child(self.user.uid).child("notes").child(key).updateChildValues(NoteDataModel.addTask(title: title , description: description))
    }

    func saveDeletedNote(title: String , description: String){
        self.ref.child("users").child(self.user.uid).child("deleteNote").childByAutoId().setValue(NoteDataModel.addTask(title: title , description: description))
    }

    func saveArchiveNote(title: String , description: String){
        self.ref.child("users").child(self.user.uid).child("archiveNote").childByAutoId().setValue(NoteDataModel.addTask(title: title , description: description))
    }

    func editArchiveNote(title: String , description: String, key:String){
        self.ref.child("users").child(self.user.uid).child("archiveNote").child(key).updateChildValues(NoteDataModel.addTask(title: title , description: description))
    }
    func fetchNotes (completion: @escaping(_ notes:[ NoteItem])->()) {
        let notesRef = Database.database().reference().child("users/\(self.user.uid)/notes")
        let lastNote = notes.last
        var quaryRef: DatabaseQuery
        if lastNote == nil{
            quaryRef = notesRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 10)
        } else {
            let lastTimestamp = lastNote!.createdAt.timeIntervalSince1970 * 1000
            quaryRef = notesRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 5)
        }
        quaryRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var newNote = [NoteItem]()
            for itemSnapShot in snapshot.children {
                if let childSnapshot = itemSnapShot as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any],
                   let title = dict["title"] as? String,
                   let description = dict["description"] as? String,
                   let timestamp = dict["timestamp"] as? Double{
                    if childSnapshot.key != lastNote?.id {
                        let note = NoteItem(snapshot: itemSnapShot as! DataSnapshot,id: childSnapshot.key,timestamp: timestamp, title: title,description: description)
                        newNote.insert(note, at: 0)
                        //newNote.append(note)
//                        print("")
                    }
                }
            }
            //self.notes = newNote
            return completion(newNote)
        })
    }
}
