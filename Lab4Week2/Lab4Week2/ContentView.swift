//
//  ContentView.swift
//  Lab4Week2
//
//  Created by Rana MHD on 15/01/1445 AH.
//

import SwiftUI

struct SignUpView : View {
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var mobileNumber: String = ""
    @State var showAlert : Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        Form {
            TextField("Username", text: $username) { isChanged in
                if !isChanged {
                    validateUsername(username)
                }
            }
            
            SecureField("Password", text: $password)
            
            TextField("Email", text: $email) { isChanged in
                if !isChanged {
                    validateEmail(email)
                }
            }
            
            TextField("Mobile Number", text: $mobileNumber) { isChanged in
                if !isChanged {
                    validateMobileNumber(mobileNumber)
                }
            }
            Spacer().frame(height: 300)
            Button {
                validateUsername(username)
                validatePassword(password)
                validateEmail(email)
                validateMobileNumber(mobileNumber)
            } label: {
                Text("Submit")
                    .padding(.all)
                    .cornerRadius(16)
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert (title: Text(alertMessage))
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
    func validateUsername(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Username should not be empty"
        } else {
            if value.count < 6 {
                showAlert = true
                alertMessage = "Username should be more than 6 characters"
            }
        }
    }

    func validateEmail(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Email should not be empty"
        } else if(!isValidEmail(email)) {
            showAlert = true
            alertMessage = "Email not in valid format"
        }
    }

    func validatePassword(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Password should not be empty"
        } else {
            if value.count < 8 {
                showAlert = true
                alertMessage = "Password should be more than 8 characters"
            }
        }
    }
    
    func validateMobileNumber(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "kindly enter a mobile number"
        } else {
            var isNumber = true
            value.forEach { char in
                if !char.isNumber {
                    isNumber = false
                    return
                }
            }
            if !isNumber {
                showAlert = true
                alertMessage = "kindly enter a valid mobile number"
                mobileNumber = ""
            }
        }
    }
}

struct SportData : Identifiable  {
    var id: UUID = UUID()
    let name : String
    let imageURL :URL?
}

struct SportView: View {
    let data : SportData
    var body: some View {
        HStack {
            NavigationLink(
                destination:{
                    VStack {
                        GeometryReader { geometryProxy in
                            ZStack {
                                AsyncImage(url: data.imageURL){ result in
                                    if let image = result.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        //Rectangle()
                                        //.fill(Color.black.opacity(0.1))
                                        ProgressView()
                                    }
                                    
                                }
                                .frame(
                                    width: geometryProxy.size.width,
                                    height :geometryProxy.size.height
                                )
                                VStack{
                                    Spacer()
                                    Text(data.name)
                                        .frame(maxWidth : .infinity ,alignment : .center)
                                }
                                .foregroundColor(.white)
                                .background(Gradient(colors: [
                                    Color.clear ,
                                    Color.clear ,
                                    Color.clear ,
                                    Color.black
                                    
                                ]  )  )
                                
                            }
                        }
                    }.navigationTitle(data.name)
                },
                label: {
                    Text(data.name)
                        .padding()
                        .frame(maxWidth : .infinity ,alignment : .leading)
                }
            )
        }
    }
}

func makeSportData() -> Array<SportData> {
    let sportData = sportList.map { sport in
        SportData(
            name: sport,
            imageURL: URL(string:"https://source.unsplash.com/200x200/?\(sport)")
        )
    }
    
    return sportData
}


struct ContentView: View {
    let sportData : Array<SportData> = makeSportData()
    
    var body: some View {
        NavigationView {
            VStack {
                List(sportData) { sport in
                    SportView(data: sport)
                }
            } .navigationTitle("Sports")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                TabView {
                    ContentView()
                        .tabItem{
                            Label("Sport" , systemImage : "doc")
                        }
                    
                    SignUpView()
                        .tabItem{
                            Label("Signup" , systemImage : "person")
                        }
                }
            }
            
        }
    }
}
let sportList : Array<String> = """
Casterboarding
Freeboard
Longboarding
Streetboarding
Scootering
Skysurfing
Streetluge
Snowboarding
Mountainboarding
Sandboarding
Snowkiting
urfing
Bodyboarding
Dog surfing
Skimboarding
Wakesurfing
Windsurfing
Wakeboarding
Kneeboarding
Paddleboarding
Standup paddleboarding
"""
    .components(separatedBy: "\n")


