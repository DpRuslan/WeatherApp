//
//  ParseService.swift
//

import Foundation

final class ParseService {
    enum Status {
        case success
        case failure(errorDescr: String)
    }
    
    static let shared = ParseService()
    
    private init() { }
    
// MARK: Generic parse func
    
    func parseResponse<T: Decodable, Y>(res: Result<Data, CustomError>, myData: inout Y, decodeStruct: T.Type, errorFlag: inout Bool, customError: inout CustomError?) {
        switch res {
        case .success(let data):
            do {
                myData = try JSONDecoder().decode(T.self, from: data) as! Y
                errorFlag = false
            } catch {
                print(error.localizedDescription)
                errorFlag = true
            }
        case .failure(let error):
            customError = error
            errorFlag = true
        }
    }
}
