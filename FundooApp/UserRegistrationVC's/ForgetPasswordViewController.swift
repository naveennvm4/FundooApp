import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleFilledButton(sendButton)
    }
    func loginVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: textEmail.text!) { (error) in
            if error != nil{
                self.openAlert(title: "Alret", message: "Error sending Email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
                return
            }
            self.openAlert(title: "Alret", message: "A Password reset email has been sent", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in}])
            self.loginVC()
        }
    }
}
