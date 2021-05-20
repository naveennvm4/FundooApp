import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate{
  
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPWButton: UIButton!
    @IBOutlet weak var fbloginButton: FBLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleFilledButton(loginButton)
        styleFilledButton(forgetPWButton)
        googleLogin()
        emailLogin()
        fbloginButton.permissions = ["public_profile", "email"]
        if let accessToken = AccessToken.current{
            //User is already login with facebook
            print(accessToken)
            facebookLogin()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        ValidationCode()
    }
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Running sign in")
        // Firebase sign in
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error")
                print(error)
                return
            }
            print("User is signed in with Google")
            self.NotesVC()
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
//        guard let token = result?.token?.tokenString else{
//            print("User failed to log in with facebbok")
//            return
//        }
//        let credential = FacebookAuthProvider.credential(withAccessToken: token)
//        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
            if let error = error{
                print(error)
                return
            }
            print("User SignInWith FaceBook")
            if let user = Auth.auth().currentUser{
                print(user)
                // User is logged in, do work such as go to next view controller.
                self.NotesVC()
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    func facebookLogin(){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
            if let error = error{
                print(error)
                return
            }
            print("User SignInWith FaceBook")
            if let user = Auth.auth().currentUser{
                print(user)
                // User is logged in, do work such as go to next view controller.
                self.NotesVC()
            }
        })
    }
    
    func emailLogin(){
        if let user = Auth.auth().currentUser{
            print(user)
            // User is already logged in, do work such as go to next view controller.
            self.NotesVC()
        }
    }
    
    func googleLogin(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            print("Already Login with Google")
        }
    }
}
extension LoginViewController{
    fileprivate func ValidationCode() {
        if let email = textEmail.text, let password = textPassword.text{
            if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Email address not found", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay Clicked!")
                }])
            }else if !password.validatePassword(){
                openAlert(title: "Alert", message: "Please enter valid Password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay Clicked!")
                }])
            }else{
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    print("HomeViewController")
                    self.NotesVC()
                }
            }
        }else{
            openAlert(title: "Alert", message: "Please enter valid Details", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay Clicked!")
            }])
        }
    }
    func NotesVC(){
        print("Home")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyBoard.instantiateViewController(identifier: "HomeVC") as! NotesViewController
        self.show(noteViewController, sender: (Any).self)
    }
}


