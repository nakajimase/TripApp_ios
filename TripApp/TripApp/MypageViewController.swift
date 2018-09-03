import UIKit
import FirebaseAuth

class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myPageTable: UITableView!

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.myPageTable.delegate = self
        self.myPageTable.dataSource = self

        self.myPageTable.register(UINib(nibName: "MyPageUserAddCell", bundle: nil), forCellReuseIdentifier: "MyPageUserAddCell")
        self.myPageTable.register(UINib(nibName: "MyPageImageCell", bundle: nil), forCellReuseIdentifier: "MyPageImageCell")
        self.myPageTable.register(UINib(nibName: "MyPageUserNameCell", bundle: nil), forCellReuseIdentifier: "MyPageUserNameCell")
        self.myPageTable.register(UINib(nibName: "MyPageTableTabCell", bundle: nil), forCellReuseIdentifier: "MyPageTableTabCell")

        if Auth.auth().currentUser != nil {
            print("User is signed in")
            user = Auth.auth().currentUser
        } else {
            print("No user is signed in")
        }

        myPageTable.rowHeight = UITableViewAutomaticDimension
        myPageTable.estimatedRowHeight = 1000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageUserAddCell") as! MyPageUserAddCell
            cell.userAddButton.addTarget(self,
                                         action: #selector(self.buttonTapped(sender:)),
                                         for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageImageCell") as! MyPageImageCell
            cell.MyImage.image = UIImage(named: "Image")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageUserNameCell") as! MyPageUserNameCell
            if let user = user {
                cell.loginUserName.text = user.email ?? "" + "さん"
            } else {
                cell.loginUserName.text = "未登録"
            }
            cell.logoutBtn.addTarget(self,
                                     action: #selector(self.logoutBtnTapped(sender:)),
                                     for: .touchUpInside)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableTabCell") as! MyPageTableTabCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageImageCell") as! MyPageImageCell
            return cell
        }
    }

    @objc func buttonTapped(sender : AnyObject) {
        self.show(MyPageUserAddViewController.instantiate(), sender: self)
    }

    @objc func logoutBtnTapped(sender: AnyObject) {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser != nil {
            print(firebaseAuth.currentUser?.email)
            do {
                try firebaseAuth.signOut()
                print(firebaseAuth.currentUser?.email ?? "Logout Success")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            print("ログインしているユーザはありません。")
        }
    }

}
