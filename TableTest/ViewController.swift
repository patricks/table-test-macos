//
//  ViewController.swift
//  TableTest
//
//  Created by Patrick Steiner on 20.02.17.
//  Copyright © 2017 Patrick Steiner. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: UI
    
    @IBAction func didPressLoadLocalButton(_ sender: NSButton) {
        dataSource.removeAll()
        
        fetchLocalData()
    }
    
    @IBAction func didPressLoadRemoteButton(_ sender: NSButton) {
        dataSource.removeAll()
        
        fetchRemoteData()
    }
    
    // MARK: Data Source
    
    /// fetch local data.
    private func fetchLocalData() {
        self.dataSource = ["Eisenstadt",
                           "Klagenfurt",
                           "Sankt Pölten",
                           "Linz",
                           "Salzburg",
                           "Graz",
                           "Innsbruck",
                           "Bregenz",
                           "Wien"]
        
        self.tableView.reloadData()
    }
    
    /// Fetch 10 remove items. Simple not thread-safe implementation.
    private func fetchRemoteData() {
        for _ in 1...10 {
            fetchData(completion: { (responseString) in
                DispatchQueue.main.async {
                    self.dataSource.append(responseString)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    /// Fetch remote data via URLSession.
    private func fetchData(completion: @escaping (_ string: String) -> ()) {
        // Allowed AppTransport Security in Info.plist
        guard let url = URL(string: "http://www.setgetgo.com/randomword/get.php") else {
            print("ERROR: failed to generate URL")
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print("ERROR: Failed to fetch word")
                return
            }
            
            guard let responseData = data else {
                print("ERROR: Can't parse response data")
                return
            }
            
            guard let responseString = String(data: responseData, encoding: String.Encoding.utf8) else {
                print("ERROR: Can't convert response data to string")
                return
            }
            
            completion(responseString)
        })
        task.resume()
    }
}

// MARK: - NSTableViewDataSource

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

// MARK: - NSTableViewDelegate

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let name = dataSource[row]
        
        if let cell = tableView.make(withIdentifier: "NameCellID", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = name
            return cell
        }
        return nil
    }
}
