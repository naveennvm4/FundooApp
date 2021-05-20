
import UIKit
import Firebase
class NoteDetailVC: UIViewController {

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    
    var noteToEdit : NoteItem?
    var isEdit = false
    var key: String?
   
    private var databasehandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit == true{
            
            titleTxt.text = noteToEdit!.title
            descriptionTxt.text = noteToEdit!.description
        }
    }

    @IBAction func deleteBtn(_ sender: UIBarButtonItem) {
        NoteRealtimeDatabase.getInstance().saveDeletedNote(title: titleTxt.text!, description: descriptionTxt.text!)
        noteToEdit?.ref?.removeValue()
        self.navigationController?.popViewController(animated: true)
        print("Notes Get Deleted and Stored in Deleted Notes")
    }
    
    @IBAction func archiveBtn(_ sender: UIBarButtonItem) {
        NoteRealtimeDatabase.getInstance().saveArchiveNote(title: titleTxt.text!, description: descriptionTxt.text!)
        noteToEdit?.ref?.removeValue()
        self.navigationController?.popViewController(animated: true)
        print("Notes Moved To Archieved Notes")
    }
    
    @IBAction func addOrEditNote(_ sender: UIButton) {
        if isEdit == true {
           NoteRealtimeDatabase.getInstance().updateNote(title: titleTxt.text!, description: descriptionTxt.text!, key: key!)
            self.navigationController?.popViewController(animated: true)
            print("Notes is Edited")
        }else{
            NoteRealtimeDatabase.getInstance().createNote(title:titleTxt.text!, description: descriptionTxt.text!)
            self.navigationController?.popViewController(animated: true)
            print("New Notes Added")
        }
    }
}
