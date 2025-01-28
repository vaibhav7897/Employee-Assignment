//
//  EmployeeModel.swift
//  employee
//
//  Created by Vaibhav Gupta on 28/01/25.
//

import Foundation

// Data model
struct ResponseData: Decodable{
    let status: String
    let data: [Employee]
    let message: String
}
struct Employee: Decodable{
    let id: Int
    let employee_name: String
    let employee_salary: Int
    let employee_age: Int
    let profile_image: String?
}
