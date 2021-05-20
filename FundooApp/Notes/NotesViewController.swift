

import UIKit
import Firebase
import FirebaseAuth
import SideMenu

class NotesViewController: UIViewController, MenuControllerDelegate {
    private var sideMenu: SideMenuNavigationController?
    var isSearching:Bool=false
    var filiteredNotes:[NoteItem] = []
    var notes = [NoteItem]()
    var user: User!
    var ref : DatabaseReference!
    private var databasehandle: DatabaseHandle!
    var gridFlowLayout = GridFlowLayout()
    var listFlowLayout = ListFlowLayout()
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 1.0
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var myToolBar: UIToolbar!
    
    
    var isGridFlowLayoutUsed: Bool = false{
        didSet{
            updateButtonApperance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuController(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)

        collectionView.collectionViewLayout = gridFlowLayout
        isGridFlowLayoutUsed = true
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        //getAllNote ()
        beginBatchFetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes.removeAll()
        //beginBatchFetch()
    }
    
    @IBAction func menuButtonTapped(){
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        switch named {
        case .notes:
            dismiss(animated: true, completion: nil)
        case .remainder:
            performSegue(withIdentifier: "showRemainder", sender: self)
        case .archive:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let archiveVC = storyBoard.instantiateViewController(identifier: "ArchiveVC") as! ArchiveViewController
            self.show(archiveVC, sender: (Any).self)
        case .deleted:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let deletedVC = storyBoard.instantiateViewController(identifier: "DeletedVC") as! DeleteNoteViewController
            self.show(deletedVC, sender: (Any).self)
        case .signOut:
            print("Signing Out")
            signOut()
        }
    }
    
    fileprivate func updateButtonApperance(){
        let layout = isGridFlowLayoutUsed ? gridFlowLayout : listFlowLayout
        UIView.animate(withDuration: 0.5){ () -> Void in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    @IBAction func toggleButton(sender: UIBarButtonItem) {
        if isGridFlowLayoutUsed{
            
            isGridFlowLayoutUsed = false
        } else{
            
            isGridFlowLayoutUsed = true
        }
        
        self.collectionView?.reloadData()
    }
    
//    func fetchNotes (completion: @escaping(_ notes:[ NoteItem])->()) {
//        let notesRef = Database.database().reference().child("users/\(self.user.uid)/notes")
//        let lastNote = self.notes.last
//        var quaryRef: DatabaseQuery
//        
//        if lastNote != nil{
//            let lastTimestamp = lastNote!.createdAt.timeIntervalSince1970 * 1000
//            quaryRef = notesRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 5)
//        } else {
//            quaryRef = notesRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 10)
//        }
//        
//        quaryRef.observeSingleEvent(of: .value, with: { snapshot in
//            
//            var newNote = [NoteItem]()
//            
//            for itemSnapShot in snapshot.children {
//                if let childSnapshot = itemSnapShot as? DataSnapshot,
//                   let dict = childSnapshot.value as? [String:Any],
//                   let title = dict["title"] as? String,
//                   let description = dict["description"] as? String,
//                   let timestamp = dict["timestamp"] as? Double {
//                    
//                    if childSnapshot.key != lastNote?.id {
//                        let note = NoteItem(snapshot: itemSnapShot as! DataSnapshot,id: childSnapshot.key,timestamp: timestamp, title: title,description: description)
//                        newNote.insert(note, at: 0)
//                        //newNote.append(note)
//                        //                        print("")
//                    }
//                }
//            }
//            return completion(newNote)
//        })
//    }
    func beginBatchFetch(){
        fetchingMore = true
        NoteRealtimeDatabase.getInstance().fetchNotes { newNotes in
            self.notes.append(contentsOf: newNotes)
            //self.notes = newNotes
            self.endReached = newNotes.count == 0
            self.fetchingMore = false
            self.collectionView.reloadData()
        }
    }
    
//    func getAllNote () {
//        let notesRef = Database.database().reference().child("users/\(self.user.uid)/notes")
//        let queryRef = notesRef.queryOrdered(byChild: "title")
//        databasehandle = queryRef.observe(.value, with: { (snapshot) in
//            var newNote = [NoteItem]()
//
//            for itemSnapShot in snapshot.children {
//                if let childSnapshot = itemSnapShot as? DataSnapshot,
//                   let dict = childSnapshot.value as? [String:Any],
//                   let title = dict["title"] as? String,
//                   let description = dict["description"] as? String,
//                   let timestamp = dict["timestamp"] as? Double{
//                    let note = NoteItem(snapshot: itemSnapShot as! DataSnapshot, id: childSnapshot.key, timestamp: timestamp, title: title,description: description)
//                    newNote.append(note)
//                    print("")
//                }
//                self.notes = newNote
//                self.collectionView.reloadData()
//                }
//            })
//        }
//    deinit {
//        ref?.child("users/\(self.user.uid)/notes").removeObserver(withHandle: databasehandle)
//    }
}

