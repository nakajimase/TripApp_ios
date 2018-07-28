import UIKit

class MyPageUserAddCell: UITableViewCell {

    @IBOutlet weak var userAddButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        userAddButton.setTitle("ユーザ情報を登録できます。", for: .normal)
    }

}
