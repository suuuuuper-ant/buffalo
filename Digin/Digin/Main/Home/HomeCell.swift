////
////  HomeCell.swift
////  Digin
////
////  Created by jinho jeong on 2021/04/23.
////
//
//import SwiftUI
//
//struct HomeCell: View {
//
//    private var company: CompanyProtocol
//
//    init(company: CompanyProtocol) {
//        self.company = company
//    }
//
//    var body: some View {
//
//            VStack(alignment: .leading) {
//                Text(company.interestingCompapny)
//
//                HStack {
//                    ForEach(company.relativedCompany, id: \.self) { (str)  in
//                        Text(str)
//                    }
//                    Button("like") {
//                        print("Like it")
//                    }.frame(width: 20, height: 20, alignment: .bottom)
//
//                }
//                BuyCellView(company: company)
//            }.padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
//
//            .frame(
//                        maxWidth: .infinity,
//                        maxHeight: .infinity,
//                        alignment: .topLeading
//                    )
//            .background(Color.red)
//
//    }
//}
//
//struct BuyCellView: View {
//    @State var company: CompanyProtocol
//    var body: some View {
//        Text(company.interestingCompapny)
//    }
//}
//
//struct HomeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeCell(company: TestCompany())
//    }
//}
//
//struct News: Codable {
//    var date: String
//    var content: String
//}
//
//protocol CompanyProtocol {
//    var interestingCompapny: String { get }
//    var relativedCompany: [String] { get }
//    var updateDate: String { get }
//    var currentPrice: String { get }
//    var subjectPrice: String { get }
//    var newsList: [News] { get }
//    var like: Bool { get }
//}
//
//struct TestCompany: CompanyProtocol, Codable, Identifiable {
//    var id: UUID = UUID()
//    var interestingCompapny: String = "쿠팡"
//    var relativedCompany: [String] = ["대신증권", "바이날", "오코리아"]
//    var updateDate: String = "21.04.13"
//    var currentPrice: String = "59000"
//    var subjectPrice: String = "64000"
//    var newsList: [News] = [News(date: "3/23", content: "뉴욕상장했다")]
//    var like: Bool = true
//
//}
