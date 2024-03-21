import SwiftUI

struct OnBoardingView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()

    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                    Spacer()
                    if page == pages.last {
                        Button("Let's Start!", action: goToZero)
                            .buttonStyle(.bordered)
                            .tint(.customorange)
                    } else {
                        Button("Next", action: incrementPage)
                            .buttonStyle(.borderedProminent)
                            .tint(.customorange)
                    }
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)// 2
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .customorange
            dotAppearance.pageIndicatorTintColor = .gray
        }
        .background(Color.customwhite)
    }

    func incrementPage() {
        pageIndex += 1
    }

    func goToZero() {
        pageIndex = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
