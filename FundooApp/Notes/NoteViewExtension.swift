//
//  NoteViewExtension.swift
//  GoogleKeep
//
//  Created by admin on 12/05/21.
//

import Foundation
import UIKit
extension NotesViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filiteredNotes.count
        }else{
            return notes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"noteCollectionCell", for: indexPath) as! NoteCollectionViewCell
        if isSearching{
            let note = filiteredNotes[indexPath.row]
            cell.titlLbl.text = note.title
            cell.descriptionLbl.text = note.description
        }else{
            let note = notes[indexPath.row]
            cell.titlLbl.text = note.title
            cell.descriptionLbl.text = note.description
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let noteDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "noteDetailVC") as? NoteDetailVC else {
            return
        }
        if isSearching {
            let note = filiteredNotes[indexPath.row]
            noteDetailVC.noteToEdit = note
            noteDetailVC.isEdit = true
            noteDetailVC.key = note.ref?.key
        }else{
            let note = notes[indexPath.row]
            noteDetailVC.noteToEdit = note
            noteDetailVC.isEdit = true
            noteDetailVC.key = note.ref?.key
        }
        navigationController?.pushViewController(noteDetailVC, animated: true )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: searchBar.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching{
            if !fetchingMore && !endReached{
                beginBatchFetch()
            }
        }
    }
}

extension NotesViewController: UISearchBarDelegate {
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        collectionView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !isSearching {
            isSearching = true
            collectionView.reloadData()
        }
      searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dismiss(animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filiteredNotes.removeAll()
        let searchPredicate = searchBar.text!
        filiteredNotes = notes.filter({$0.title.lowercased().range(of: searchPredicate.lowercased()) != nil})
        isSearching = (filiteredNotes.count == 0) ? false: true
        collectionView?.reloadData()
    }
}
