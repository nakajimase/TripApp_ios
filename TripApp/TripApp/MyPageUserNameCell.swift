import UIKit

class MyPageUserNameCell: UITableViewCell {

    @IBOutlet weak var loginUserName: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
