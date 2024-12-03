//
//  AuthHeaderView.swift
//  AllerBite
//
//  Created by Sahil Aggarwal on 13/10/24.
//

import SwiftUI

struct AuthHeaderView: View {
    let title1: String
    let title2: String
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{Spacer()}
            Text(title1)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(title2)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(height:260)
        .padding(.leading)
        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
        .foregroundColor(.white)
        .clipShape(RoundedShape(corners: [.bottomRight]))
    }
}

#Preview {
    AuthHeaderView(title1: "Hello", title2: "Welcome Back")
}
