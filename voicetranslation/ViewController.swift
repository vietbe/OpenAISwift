//
//  ViewController.swift
//  voicetranslation
//
//  Created by BaoViet on 01/03/2023.
//

import UIKit

//let api_key = "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"
//let headers: HTTPHeaders = ["Authorization": "Bearer \(api_key)","Content-Type":"application/json"]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let field: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Type here..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = .green
//        textField.returnKeyType = .done
//        return textField
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.backgroundColor = .systemGray6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.returnKeyType = .done
        field.placeholder = "Please Enter A Prompt"
        field.contentVerticalAlignment = .top
        return field
    }()
    
    private var models = [String]()
    
    private let table: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(field)
        view.addSubview(table)
        view.addSubview(submitButton)
        
        field.delegate = self
        table.delegate = self
        table.dataSource = self
        
        NSLayoutConstraint.activate([
            //field.heightAnchor.constraint(equalToConstant: 50),
            //field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            //field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            //field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            //field.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            //field.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //field.widthAnchor.constraint(equalToConstant: 300),
            //field.heightAnchor.constraint(equalToConstant: 150),
            
            //table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            //table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            //table.topAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            //table.bottomAnchor.constraint(equalTo: field.topAnchor)
            
            
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.widthAnchor.constraint(equalToConstant: 300),
            table.heightAnchor.constraint(equalToConstant: 300),
            
            field.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 20),
            field.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            field.widthAnchor.constraint(equalToConstant: 300),
            field.heightAnchor.constraint(equalToConstant: 150),
            
            submitButton.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 300),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            
            
        ])
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            models.append(text)
            APICaller.shared.getResponse(input: text) { [weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.field.text = nil
                    }
                case .failure:
                    print("Failed")
                }
            }
        }
        return false
    }
    
    @objc func didTapSubmit() {
        
        print("=========")
        
        
        field.resignFirstResponder()
        
        let text = field.text
        
        models.append(text!)
        APICaller.shared.getResponse(input: text!) { [weak self] result in
            switch result {
            case .success(let output):
                self?.models.append(output)
                DispatchQueue.main.async {
                    self?.table.reloadData()
                    self?.field.text = nil
                }
            case .failure:
                print("Failed")
            }
        }
    }
    
    
}

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
////        vietnameseToEnglish(text: "Đây là một ví dụ về việc chuyển đổi giọng nói từ tiếng Việt sang tiếng Anh bằng Swift và OpenAI.") { result in
////            if let englishText = result {
////                print("Đoạn văn bản tiếng Anh: \(englishText)")
////            } else {
////                print("Chuyển đổi không thành công.")
////            }
////        }
//
//        vietnameseToEnglish()
//
//    }
//
//    func vietnameseToEnglish() {
//
//
//        //let prompt = "translate Vietnamese to English: \(text)"
//        let parameters: Parameters = [
//            "model": "text-davinci-003",
//            "prompt": "What is quantum mechanics?",
//            "temperature": 0.7,
//            "max_tokens": 20,
//            "top_p": 1,
//            "frequency_penalty": 0,
//            "presence_penalty": 0
//        ]
//
////        curl https://api.openai.com/v1/completions \
////          -H "Content-Type: application/json" \
////          -H "Authorization: Bearer $OPENAI_API_KEY" \
////          -d '{
////          "model": "text-davinci-003",
////          "prompt": "Translate this into 1. French, 2. Spanish and 3. Japanese:\n\nWhat rooms do you have available?\n\n1.",
////          "temperature": 0.3,
////          "max_tokens": 100,
////          "top_p": 1.0,
////          "frequency_penalty": 0.0,
////          "presence_penalty": 0.0
////        }
//
//        AF.request("https://api.openai.com/v1/completions", method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON ( completionHandler:{ response in
//            switch response.result {
//            case .success(let data):
//                //let json = value as! NSDictionary
//
//                let json = JSON(data)
//                print(json)
//
//                print("======", json)
//                //let englishText = json["choices"]![0]["text"] as? String
//                //completion(englishText)
//            case .failure(let error):
//                print(error)
//                //completion(nil)
//            }
//        }
//    )}
//
//
//}

