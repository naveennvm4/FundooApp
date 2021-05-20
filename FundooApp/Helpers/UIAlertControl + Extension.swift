import Foundation
import UIKit
import FirebaseAuth

extension UIViewController{
    
    // Global Alert
    public func openAlert(title: String,
                         message: String,
                         alertStyle:UIAlertController.Style,
                         actionTitles:[String],
                         actionStyles:[UIAlertAction.Style],
                         actions: [((UIAlertAction) -> Void)]){
       
       let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
       for(index, indexTitle) in actionTitles.enumerated(){
           let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
           alertController.addAction(action)
       }
       self.present(alertController, animated: true)
   }
    // Define Your number of buttons, styles and completion
    func styleFilledButton(_ button:UIButton){
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
}

extension SignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            profileImage.image = img
        }
        dismiss(animated: true)
    }
    func loginVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension NotesViewController{
    
    func signOut(){
        print("SignOut in Progress...")
        let auth = Auth.auth()
        do{
            try auth.signOut()
            print("SignOut")
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }catch{
            openAlert(title: "Alert", message: "Error", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay Clicked!")
            }])
        }
    }
}
