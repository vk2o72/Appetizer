//
//  ImageLoader.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 04/08/24.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: Image? = nil
    
    func fetchImage(from urlString: String) async {
        guard let image = await NetworkManager.shared.downloadImage(from: urlString) else { return }
        
        await MainActor.run {
            self.image = Image(uiImage: image)
        }
    }
}

struct RemoteImage: View {
    var image: Image?
    
    var body: some View {
        self.image?.resizable() ?? Image(uiImage: UIImage.sample).resizable()
    }
}


struct AppetizerRemoteImage: View {
    @StateObject var imageLoader = ImageLoader()
    var urlString: String
    
    var body: some View {
        RemoteImage(image: self.imageLoader.image)
            .task(priority: .high, {
                await self.imageLoader.fetchImage(from: self.urlString)
            })
    }
}

#Preview {
    AppetizerRemoteImage(urlString: "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg")
}
