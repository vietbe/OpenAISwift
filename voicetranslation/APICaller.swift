//
//  APICaller.swift
//  voicetranslation
//
//  Created by BaoViet on 01/03/2023.
//

import OpenAISwift
import Foundation

final class APICaller {
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "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"
    }
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .codex(.davinci), completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices.first?.text ?? ""
                completion(.success((output)))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}

