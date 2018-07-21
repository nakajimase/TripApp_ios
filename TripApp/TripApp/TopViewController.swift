import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!

    private var articlesList: [[String: String?]] = []
    var article_id: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        self.listTableView.register(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.articlesList.count == 0 {
            return 0
        } else {
            return self.articlesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell") as! TopTableViewCell
        let article = articlesList[indexPath.row]
        cell.titleLabel?.text = article["title"] as? String
        cell.subLabel?.text = article["area"] as? String
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
                        cell.topImage.image = image
                    }else{ //Error
                        print("AsyncImageView:Error \(err?.localizedDescription)")
                    }
            }).resume();
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! DetailViewController
        self.present(nextView, animated: true, completion: nil)
    }

    func getData() {
        Alamofire.request("http://13.59.253.231/article/getList").responseJSON{ response in
            guard let object = response.result.value else {return}
            let listJsonData = JSON(object)
//            print(listJsonData)
            listJsonData.forEach {(_, listJsonData) in
                let article: [String: String?] = [
                    "id": listJsonData["article_id"].stringValue,
                    "title": listJsonData["article_title"].string,
                    "area": listJsonData["area"].string,
                    "category": listJsonData["category"].string
                ]
                self.articlesList.append(article)
            }
            self.listTableView.reloadData()
            SVProgressHUD.dismiss()
        }
        SVProgressHUD.show()
    }
}

