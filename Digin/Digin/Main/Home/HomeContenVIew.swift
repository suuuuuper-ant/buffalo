////
////  HomeContenVIew.swift
////  Digin
////
////  Created by jinho jeong on 2021/04/22.
////
//
//import SwiftUI
//
//struct HomeContenVIew: View {
//
//    private var company: [TestCompany] = [TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany(), TestCompany()]
//    var body: some View {
//
//        NoSepratorList(spacing: 20) {
//            Section(header: Text("Original")) {
//                ForEach(self.company) {
//                    HomeCell(company: $0)
//                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//                        .onTapGesture {
//                            print("code")
//                        }
//
//                }
//            }
//
//        }
//
//    }
//}
//
//struct HomeContenVIew_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeContenVIew()
//    }
//}
//
//struct ListSeparatorStyle: ViewModifier {
//
//    let style: UITableViewCell.SeparatorStyle
//
//    func body(content: Content) -> some View {
//        content
//            .onAppear {
//                UITableView.appearance().separatorStyle = self.style
//            }
//    }
//}
//
//extension View {
//
//    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
//        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style))
//    }
//}
//
//struct NoSepratorList<Content>: View where Content: View {
//
//    let content: () -> Content
//    var spacing: CGFloat = 0
//    init(spacing: CGFloat, @ViewBuilder content: @escaping () -> Content) {
//        self.content = content
//        self.spacing = spacing
//
//    }
//
//    var body: some View {
//        if #available(iOS 14.0, *) {
//           ScrollView {
//               LazyVStack(spacing: spacing) {
//                self.content()
//             }
//           }
//        } else {
//            List {
//                self.content()
//            }
//            .onAppear {
//               UITableView.appearance().separatorStyle = .none
//            }.onDisappear {
//               UITableView.appearance().separatorStyle = .singleLine
//            }
//        }
//    }
//}
