import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import GoogleSignIn
import FBSDKLoginKit

class MyPageUserAddViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var googleBtn: UIView!
    @IBOutlet weak var facebookBtn: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO(developer) Configure the sign-in button look/feel
        // ...

        // Do any additional setup after loading the view.
        emailLabel.text = "testtest@gmail.com"
        passwordLabel.text = "testtest"

        // Google Login
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
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





    @IBAction func createUserTapped(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) { (user, error) in
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

    @IBAction func loginUserTapped(_ sender: UIButton) {
        if Auth.auth().currentUser == nil {
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) {(user, error) in
                if user != nil {
                    print("Login Success")
                    print(user?.user.email)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Login Error")
                    self.emailLabel.text = ""
                    self.passwordLabel.text = ""
                }
            }
        } else {
            print("すでにログインされています")
            print(Auth.auth().currentUser?.email)
        }
    }

    // Google Login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else { return }
        // Googleのトークンを渡し、Firebaseクレデンシャルを取得する。
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Firebaseにログインする。
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("login failed! \(error)")
                return
            }
            // すでに登録済みのユーザはどうやって判定するか。
//            if let user = user {
//                print("user : \(user.email) has been signed in successfully.")
//            } else {
                print("Sign on Firebase successfully")
                // performSegue でログイン後のVCへ遷移させる。
                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Sign off successfully")
    }

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
