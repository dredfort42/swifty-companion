//
//  OAuth.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 31.10.2022.
//

//	----- INFO LINKS -----
//	https://api.intra.42.fr/apidoc/guides/getting_started
//	https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#using-alamofire
//	----------------------

import Foundation
import Alamofire
import SwiftyJSON

class OAuth {
	
	static func getToken() {
		if !UserDefaults.standard.bool(forKey: "token") {
			let url: URLConvertible = "https://api.intra.42.fr/oauth/token"
			let parameters: Parameters = [
				"grant_type" : "client_credentials",
				"client_id" : (ProcessInfo.processInfo.environment["client_id"] ?? "") as String,
				"client_secret" : (ProcessInfo.processInfo.environment["client_secret"] ?? "") as String
			]
			var token: String = ""
			AF.request(
				url,
				method: .post,
				parameters: parameters
			)
			.validate(statusCode: 200..<201)
			.validate(contentType: ["application/json"])
			.responseData {
				response in
				switch response.result {
					case .success:
						print("[v] Token received")
						if let responseValue = response.value {
							let jsonData = JSON(responseValue)
							token = jsonData["access_token"].stringValue
							UserDefaults.standard.set(token, forKey: "token")
						}
						print("TOKEN: " + token)
						OAuth.checkToken()
					case .failure:
						print("[x] Token receive error")
				}
			}
		}
	}

	static func checkToken() {
		let token: String = UserDefaults.standard.string(forKey: "token") ?? ""
		let url: URLConvertible = "https://api.intra.42.fr/oauth/token/info"
		let headers: HTTPHeaders = ["Authorization" : "Bearer " + token]
		AF.request(
			url,
			method: .get,
			headers: headers
		)
		.validate()
		.responseData {
			response in
			switch response.result {
				case .success:
					print("[v] Valid token")
					print(JSON(response.value!))
				case .failure:
					print("[x] Invalid token")
					print("Trying receive new one...")
					OAuth.getToken()
			}
		}
	}
}
