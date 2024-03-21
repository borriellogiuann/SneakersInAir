import SwiftUI

struct PageView: View {
    var page: Page

    var body: some View {
        VStack(spacing: 30) {
            Image("\(page.imageUrl)")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)

            VStack(spacing: 1) {
                Text(page.name)
                    .font(.title)
                    .foregroundColor(.black)

                Text(page.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }

        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(page: Page.samplePage)
    }
}
