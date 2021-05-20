import UIKit
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.addGestureRecognizer(tapGesture)
        styleFilledButton(signUpButton)
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        print("Select Image From Gallary")
        openGallery()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let imgSystem = UIImage(systemName: "person.crop.circle.badge.plus")
        
        if profileImage.image?.pngData() != imgSystem?.pngData(){
            // profile image selected
            if let email = textEmail.text, let password = textPassword.text, let username = textUsername.text{
                if username == ""{
                    openAlert(title: "Alert", message: "Please enter UserName", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("Please enter username")
                }else if !email.validateEmailId(){
                    openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("email is not valid")
                }else if !password.validatePassword(){
                    openAlert(title: "Alert", message: "Please enter valid Password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("Password is not valid")
                } else{
                    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                        if error != nil{
                            self.openAlert(title: "Alert", message: "Error Creating User", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                        }else{
                            print("HomeViewController")
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let noteViewController = storyBoard.instantiateViewController(identifier: "HomeVC") as! NotesViewController
                            self.show(noteViewController, sender: (Any).self)
                        }
                    }
                }
            }else{
                print("Please check your details")
            }
        }else{
            print("Please select profile picture")
            openAlert(title: "Alert", message: "Please select profile picture", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
        }
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginVC()
    }
}


