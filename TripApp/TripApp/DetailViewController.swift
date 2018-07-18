import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backPage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
