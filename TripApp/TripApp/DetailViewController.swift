import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTable: UITableView!

    private var article: [String: String?]!
    private var article_id: String!

    class func instantiate(article_id: String) -> DetailViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! DetailViewController
        controller.article_id = article_id
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.detailTable.delegate = self
        self.detailTable.dataSource = self

        self.detailTable.register(UINib(nibName: "DetailTopImageCell", bundle: nil), forCellReuseIdentifier: "DetailTopImageCell")
        self.detailTable.register(UINib(nibName: "DetailTitleCell", bundle: nil), forCellReuseIdentifier: "DetailTitleCell")
        self.detailTable.register(UINib(nibName: "DetailContentsTextCell", bundle: nil), forCellReuseIdentifier: "DetailContentsTextCell")
        self.detailTable.register(UINib(nibName: "DetailMapCell", bundle: nil), forCellReuseIdentifier: "DetailMapCell")

        getDetailData(withID: article_id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(self.article != nil) {
            return 0
        } else {
            return 4
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 1:
            return 65
        case 2:
            return 400
        case 3:
            return 250
        default:
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTopImageCell") as! DetailTopImageCell
            if let article_id = article["id"] as? String {
                let urlString = "http://13.59.253.231/images/" + article_id + "/1.jpg"
                let CACHE_SEC : TimeInterval = 5 * 60

                let req = URLRequest(url: NSURL(string:urlString)! as URL,
                                     cachePolicy: .returnCacheDataElseLoad,
                                     timeoutInterval: CACHE_SEC);
                let conf =  URLSessionConfiguration.default;
                let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);

                session.dataTask(with: req, completionHandler:
                    { (data, resp, err) in
                        if((err) == nil){ //Success
                            let image = UIImage(data:data!)
                            cell.topImageView.image = image
                        }else{ //Error
                            print("AsyncImageView:Error \(err?.localizedDescription)")
                        }
                }).resume();
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTitleCell") as! DetailTitleCell
            cell.mainTitle.text = article["title"] as? String
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContentsTextCell") as! DetailContentsTextCell
            cell.detailContentText.text = article["article_text"] as? String
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMapCell") as! DetailMapCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTopImageCell") as! DetailTopImageCell
            return cell
        }
    }

    func getDetailData(withID id: String) {
        Alamofire.request("http://13.59.253.231/article/getDetail/" + id).responseJSON{ response in
            guard let object = response.result.value else {return}
            let listJsonData = JSON(object)
//            print(listJsonData)
            listJsonData.forEach {(_, listJsonData) in
                self.article = [
                    "id": listJsonData["article_id"].stringValue,
                    "title": listJsonData["article_title"].string,
                    "article_text": listJsonData["article_text"].string,
                    "address": listJsonData["address"].string,
                    "latitude": listJsonData["latitude"].stringValue,
                    "longitude": listJsonData["longitude"].stringValue
                ]
            }
            self.detailTable.reloadData()
            SVProgressHUD.dismiss()
        }
        SVProgressHUD.show()
    }
}
