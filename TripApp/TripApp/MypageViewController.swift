import UIKit

class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myPageTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.myPageTable.delegate = self
        self.myPageTable.dataSource = self

        self.myPageTable.register(UINib(nibName: "MyPageUserAddCell", bundle: nil), forCellReuseIdentifier: "MyPageUserAddCell")
        self.myPageTable.register(UINib(nibName: "MyPageImageCell", bundle: nil), forCellReuseIdentifier: "MyPageImageCell")
        self.myPageTable.register(UINib(nibName: "MyPageUserNameCell", bundle: nil), forCellReuseIdentifier: "MyPageUserNameCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 55
        case 1:
            return 200
        case 3:
            return 55
        default:
            return 55
        }
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
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageUserNameCell") as! MyPageUserNameCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageImageCell") as! MyPageImageCell
            return cell
        }
    }

    @objc func buttonTapped(sender : AnyObject) {
        self.show(MyPageUserAddViewController.instantiate(), sender: self)
    }

}
