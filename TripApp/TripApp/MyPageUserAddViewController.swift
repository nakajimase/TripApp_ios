import UIKit

class MyPageUserAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
