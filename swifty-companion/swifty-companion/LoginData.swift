//
//  LoginData.swift
//  swifty-companion
//
//  Created by Dmitry Novikov on 02.11.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginData {

	static func getLoginInformation(login: String, completionOfReceipt: @escaping (JSON?) -> Void)
	{
		OAuth.checkToken()
		let token: String = UserDefaults.standard.string(forKey: "token") ?? ""
		let url: URLConvertible = "https://api.intra.42.fr/v2/users/" + login
		let headers: HTTPHeaders = ["Authorization" : "Bearer " + token]
		
		AF.request(
			url,
			method: .get,
			headers: headers
		)
		.responseData {
			response in
			switch response.result {
				case .success:
					print("[v] Information requested")
					completionOfReceipt(JSON(response.value!))
				case .failure:
					print("[x] Information not requested")
					completionOfReceipt(nil)
			}
		}
	}

}
