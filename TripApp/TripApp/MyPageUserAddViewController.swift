import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import GoogleSignIn
import FBSDKLoginKit

class MyPageUserAddViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var facebookBtn: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO(developer) Configure the sign-in button look/feel
        // ...

        // Do any additional setup after loading the view.
        label1.text = "E-mail"
        emailLabel.text = "testtest@gmail.com"
        label2.text = "Password"
        passwordLabel.text = "testtest"
        createUserBtn.setTitle("新規作成/ログイン", for: .normal)

        // Google Login
        GIDSignIn.sharedInstance().uiDelegate = self
        let signInButton = GIDSignInButton()
        googleBtn.addSubview(signInButton)

        // Facebook Login
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        facebookBtn.addSubview(loginButton)
    }

    class func instantiate() -> MyPageUserAddViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "MyPageUserAddViewController", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! MyPageUserAddViewController
        return controller
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }





    // Facebook Login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
//        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if let error = error {
//                return
//            }
//            // User is signed in
//        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }





    // User/Password Create/Login
    @IBAction func createUserTaped(_ sender: UIButton) {
        // ユーザ新規作成のメソッド
        Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) { (user, error) in
        // ユーザログインのメソッド
//        Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) {(user, error) in
        if user != nil {
                print("success")
                print(user?.user.email)
            } else {
                print("error")
                self.emailLabel.text = ""
                self.passwordLabel.text = ""
            }
        }
    }

    // Google Login
//    @IBAction func googleLogin(_ sender: UIButton) {
////        GIDSignIn.sharedInstance().signIn()
//        let authUI = FUIAuth.defaultAuthUI()
//        let authViewController = authUI?.authViewController()
//        let googleProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIGoogleAuth
//        googleProvider.signIn(withDefaultValue: "", presenting: authViewController)
//    }
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
//        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//            return true
//        }
//        // other URL handling goes here.
//        return false
//    }

//    @IBAction func facebookLoginBtn(_ sender: UIButton) {
//        let authUI = FUIAuth.defaultAuthUI()
//        let authViewController = authUI?.authViewController()
//        let facebookProvider = FUIAuth.defaultAuthUI()?.providers.last as! FUIFacebookAuth
//        facebookProvider.signIn(withDefaultValue: "", presenting: authViewController)
//    }
}
