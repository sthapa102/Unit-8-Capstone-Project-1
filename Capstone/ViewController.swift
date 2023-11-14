import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [String] = [] // Array to store tweets

    @IBOutlet weak var tableView: UITableView! //

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchTrendingTweets()
    }

    func fetchTrendingTweets() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    // Parsing the JSON data
                    self.tweets = json.compactMap { $0["title"] as? String }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let parsingError {
                print("Error parsing JSON: \(parsingError)")
            }
        }.resume()
    }


    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath)
        cell.textLabel?.text = tweets[indexPath.row]
        return cell
    }
}
