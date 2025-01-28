//
//  EmployeeViewModel.swift
//  employee
//
//  Created by Vaibhav Gupta on 28/01/25.
//

import Foundation
import Combine
import SwiftUI

class EmployeeViewModel: ObservableObject{
    
    @Published var employees: [Employee] = []
    @Published var error: String?
    @Published var isError: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchEmployee(){
        //making network request for getting employee list from the API
        NetworkManager.shared.fetchData(from: .getEmployee)
            .sink { completion in
                switch completion{
                case.finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    self.isError = true
                }
            } receiveValue: { (response: ResponseData) in
                DispatchQueue.main.async {
                    self.employees = response.data
                }
            }
            .store(in: &cancellables)
    }
}
