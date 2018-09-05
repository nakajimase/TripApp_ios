import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON
import Alamofire
import TwitterKit
import LineSDK

public protocol LoginDelegate: NSObjectProtocol {
    func onLoginBtnTouchUpInside(user: User?) -> Void
}

class MyPageUserAddViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate, LineSDKLoginDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var googleBtn: GIDSignInButton!
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    @IBOutlet weak var twitterBtn: TWTRLogInButton!
    @IBOutlet weak var lineBtn: UIView!
    
    weak var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Google Login
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Facebook Login
        facebookBtn.delegate = self
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

    // E-mail User Create
    @IBAction func createUserTapped(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) { (user, error) in
            if user != nil {
                print("Firebase Success")
                print(user?.user.email ?? "")
                self.addDatabase(user: self.emailLabel.text ?? "", password: self.passwordLabel.text ?? "")
                // performSegue でログイン後のVCへ遷移させる。
                self.delegate?.onLoginBtnTouchUpInside(user: user?.user ?? nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                // すでに作成済みのユーザの場合、エラーになる。
                print("Firebase Error")
            }
        }
    }

    // E-mail Login
    @IBAction func loginUserTapped(_ sender: UIButton) {
        if Auth.auth().currentUser == nil {
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) {(user, error) in
                if user != nil {
                    print("Login Success")
                    print(user?.user.email)
                    self.delegate?.onLoginBtnTouchUpInside(user: user?.user ?? nil)
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
            self.emailLabel.text = ""
            self.passwordLabel.text = ""
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
            // すでに登録済みのユーザはどうやって判定するか。TODO
//            if let user = user {
//                print("user : \(user.email) has been signed in successfully.")
//            } else {
                print("Sign on Firebase successfully")

                self.addDatabase(user: user?.email ?? "", password: "")
//            }
            // performSegue でログイン後のVCへ遷移させる。
            self.navigationController?.popViewController(animated: true)
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Sign out successfully")
    }

    // Facebook Login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("login failed! \(error)")
                return
            }
            // すでに登録済みのユーザはどうやって判定するか。TODO
//            if let user = user {
//                print("user : \(user.email) has been signed in successfully.")
//            } else {
                print("Sign on Firebase successfully")

                self.addDatabase(user: user?.email ?? "", password: "")
//            }
            // performSegue でログイン後のVCへ遷移させる。
            self.navigationController?.popViewController(animated: true)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout Success")
    }
    @IBAction func twitterLogin(_ sender: TWTRLogInButton) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)")

                let credential = TwitterAuthProvider.credential(withToken: session?.authToken ?? "",
                                                                secret: session?.authTokenSecret ?? "")
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("login failed! \(error)")
                        return
                    }
                    // すでに登録済みのユーザはどうやって判定するか。TODO
//                    if let user = user {
//                        print("user : \(user.email) has been signed in successfully.")
//                    } else {
                        print("Sign on Firebase successfully")

                        self.addDatabase(user: user?.email ?? "twitter", password: "")
//                    }
                    // メールアドレス・パスワード入力画面に遷移させる。TODO
                    // performSegue でログイン後のVCへ遷移させる。
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("error: \(error?.localizedDescription)")
            }
        })
    }
    
    // Line Login
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        if let error = error {
            print("login failed! \(error)")
            return
        }
        print("Login Success")
        // performSegue でログイン後のVCへ遷移させる。
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func lineLogIn(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
    }
    
    func addDatabase(user: String, password: String) {
        let urlString = "http://13.59.253.231/user/add"
        let parameters: Parameters = [
            "email_address": user,
            "password": password
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                print(response.result)
        }
    }

}
