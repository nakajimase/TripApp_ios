import UIKit

class DetailMapCell: UITableViewCell {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var addressText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
