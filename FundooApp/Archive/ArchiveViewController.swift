
import UIKit
import Firebase
import FirebaseAuth

class ArchiveViewController: UIViewController {
    
    var isSearching:Bool=false
    var filiteredNotes:[NoteItem] = []
    var archiveNote = [NoteItem]()
    var user: User!
    var ref : DatabaseReference!
    private var databasehandle: DatabaseHandle!
    var gridFlowLayout = GridFlowLayout()
    var listFlowLayout = ListFlowLayout()
    
    @IBOutlet weak var toogleButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = gridFlowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        isGridFlowLayoutUsed = true
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        getAllArchiveNote()
        collectionView.reloadData()
    }
   
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyBoard.instantiateViewController(identifier: "HomeVC") as! NotesViewController
        self.show(noteViewController, sender: (Any).self)
    }
    
    var isGridFlowLayoutUsed: Bool = false{
        didSet{
            updateButtonApperance()
        }
    }
    
   fileprivate func updateButtonApperance(){
       let layout = isGridFlowLayoutUsed ? gridFlowLayout : listFlowLayout
       UIView.animate(withDuration: 0.5){ () -> Void in
           self.collectionView.collectionViewLayout.invalidateLayout()
           self.collectionView.setCollectionViewLayout(layout, animated: true)
       }
   }
    
   @IBAction func toggleButtonTapped(sender: UIBarButtonItem) {
       if  isGridFlowLayoutUsed {

           isGridFlowLayoutUsed = false
       }else {
        
           isGridFlowLayoutUsed = true
       }
       self.collectionView?.reloadData()
   }
    
    func getAllArchiveNote () {
        let archiveRef = Database.database().reference().child("users/\(self.user.uid)/archiveNote")
        let queryRef = archiveRef.queryOrdered(byChild: "title")
        databasehandle = queryRef.observe(.value, with: { (snapshot) in
            var newNote = [NoteItem]()
            
            for itemSnapShot in snapshot.children {
                if let childSnapshot = itemSnapShot as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any],
                   let title = dict["title"] as? String,
                   let description = dict["description"] as? String,
                   let timestamp = dict["timestamp"] as? Double{
                    let note = NoteItem(snapshot: itemSnapShot as! DataSnapshot, id: childSnapshot.key, timestamp: timestamp, title: title,description: description)
                    newNote.append(note)
                    print("")
                }
                self.archiveNote = newNote
                self.collectionView.reloadData()
            }
        })
    }
    
   deinit {
       ref?.child("users/\(self.user.uid)/archiveNote").removeObserver(withHandle: databasehandle)
   }
}
