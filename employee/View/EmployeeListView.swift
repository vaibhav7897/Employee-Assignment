//
//  EmployeeView.swift
//  employee
//
//  Created by Vaibhav Gupta on 28/01/25.
//

import Foundation
import SwiftUI

struct EmployeeListView: View {
    @StateObject var viewModel = EmployeeViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                List(viewModel.employees, id: \.id) { employee in
                    HStack{
                        // Using AsyncImage for fetching the image using image url
                        AsyncImage(url: URL(string: employee.profile_image ?? "")) { phase in
                            switch phase {
                            case .empty: // No image is loaded.
                                ProgressView()
                                    .frame(width: 50,height: 50)
                                    .clipShape(Circle())
                                    .padding(5)
                            case .success(let image): //Image loaded successfully
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(5)
                            case .failure(_): // Failed to load image with error
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(5)
                            @unknown default: // default case
                                EmptyView()
                            }
                        }
                        HStack {
                            VStack(alignment: .leading,spacing: 6) {
                                Text(employee.employee_name)
                                    .font(.headline)
                                
                                Text("Age: \(employee.employee_age)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            .contextMenu {
                                Button{
                                    copyEmployeeInfo(employee: employee)
                                }label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                Button{
                                    deleteEmployee(employee: employee)
                                }label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            Spacer()
                            Text("Salary: \(employee.employee_salary)")
                                .font(.subheadline)
                        }
                        
                    }
                }
                .onAppear {
                    viewModel.fetchEmployee()
                }
                .navigationTitle("Employees")
                .listStyle(.grouped)
                .alert("Error", isPresented: $viewModel.isError) {
                    Button("OK", role: .cancel) { }
                }
                VStack {
                    // Error message with animation
                    if viewModel.isError {
                        Text("Something went wrong!")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: viewModel.isError)
                    } else if viewModel.employees.isEmpty {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: viewModel.employees.isEmpty) // Animate loading state
                    }
                }
                .zIndex(1)
            }
            
        }
    }
    
    private func copyEmployeeInfo(employee: Employee) {
        // Adding the selected employee at the bottom the the list
        withAnimation(.easeInOut){
            viewModel.employees.append(employee)
        }
    }
    
    private func deleteEmployee(employee: Employee) {
        // fetching the index of selected employee and then after removing it
        withAnimation(.smooth) {
            if let index = viewModel.employees.firstIndex(where: { $0.id == employee.id }) {
                viewModel.employees.remove(at: index)
            }
        }
    }
}
#Preview {
    EmployeeListView()
}
