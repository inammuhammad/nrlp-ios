//
//  TermsAndConditionViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class TermsAndConditionViewModelTests: XCTestCase {

    var router = TermsAndConditionRouterMock(navigationController: BaseNavigationController())

    func testIsTermsAccepted() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServicePositiveMock(), registerUserService: RegisterUserServicePositiveMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.isTermsAccepted = true
        
        XCTAssertTrue(outputHandler.nextButtonEnabled)
        
        viewModel.isTermsAccepted = false
        
        XCTAssertTrue(outputHandler.nextButtonDisabled)
    }
    
    func testViewModelDidLoadPositive() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServicePositiveMock(), registerUserService: RegisterUserServicePositiveMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        XCTAssertNotNil(outputHandler.updateTermsAndCondition)
        XCTAssertEqual(outputHandler.updateTermsAndCondition?.string, "Welcome to 1Link-NRLP\nThese terms and conditions outline the rules and regulations for the use of 1LINK\'s Mobile App.\n\n1Link-Nrlp is located at:\n\nBy accessing this website we assume you accept these terms and conditions in full. Do not continue to use LUMS\'s website if you do not accept all of the terms and conditions stated on this page.\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and any or all Agreements: \"Client\", \"You\" and \"Your\" refers to you, the person accessing this website and accepting the Company\'s terms and conditions. \"The Company\", \"Ourselves\", \"We\", \"Our\" and \"Us\", refers to our Company. \"Party\", \"Parties\", or \"Us\", refers to both the Client and ourselves, or either the Client or ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner, whether by formal meetings of a fixed duration, or any other means, for the express purpose of meeting the Client\'s needs in respect of provision of the Company\'s stated services/products, in accordance with and subject to, prevailing law of . Any use of the above terminology or other words in the singular, plural, capitalisation and/or he/she or they, are taken as interchangeable and therefore as referring to same.\nCookies\nWe employ the use of cookies. By using LUMS\'s website you consent to the use of cookies in accordance with LUMS\'s privacy policy.\nMost of the modern day interactive web sites use cookies to enable us to retrieve user details for each visit. Cookies are used in some areas of our site to enable the functionality of this area and ease of use for those people visiting. Some of our affiliate / advertising partners may also use cookies.\nLicense\nUnless otherwise stated, LUMS and/or it\'s licensors own the intellectual property rights for all material on LUMS. All intellectual property rights are reserved. You may view and/or print pages from http://www.abc.com for your own personal use subject to restrictions set in these terms and conditions.\nYou must not:\n\t1.\tRepublish material from http://www.abc.com\n\t2.\tSell, rent or sub-license material from http://www.abc.com\n\t3.\tReproduce, duplicate or copy material from http://www.abc.com\nRedistribute content from LUMS (unless content is specifically made for redistribution).\nHyperlinking to our Content\n\t1.\tThe following organizations may link to our Web site without prior written approval:\n\t1.\tGovernment agencies;\n\t2.\tSearch engines;\n\t3.\tNews organizations;\n\t4.\tOnline directory distributors when they list us in the directory may link to our Web site in the same manner as they hyperlink to the Web sites of other listed businesses; and\n\t5.\tSystemwide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.\n\t2.\tThese organizations may link to our home page, to publications or to other Web site information so long as the link: (a) is not in any way misleading; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party\'s site. \n\t3.\tWe may consider and approve in our sole discretion other link requests from the following types of organizations:\n\t1.\tcommonly-known consumer and/or business information sources such as Chambers of Commerce, American Automobile Association, AARP and Consumers Union;\n\t2.\tdot.com community sites;\n\t3.\tassociations or other groups representing charities, including charity giving sites,\n\t4.\tonline directory distributors;\n\t5.\tinternet portals;\n\t6.\taccounting, law and consulting firms whose primary clients are businesses; and\n\t7.\teducational institutions and trade associations.\nWe will approve link requests from these organizations if we determine that: (a) the link would not reflect unfavorably on us or our accredited businesses (for example, trade associations or other organizations representing inherently suspect types of business, such as work-at-home opportunities, shall not be allowed to link); (b)the organization does not have an unsatisfactory record with us; (c) the benefit to us from the visibility associated with the hyperlink outweighs the absence of LUMS; and (d) where the link is in the context of general resource information or is otherwise consistent with editorial content in a newsletter or similar product furthering the mission of the organization.\nThese organizations may link to our home page, to publications or to other Web site information so long as the link: (a) is not in any way misleading; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and it products or services; and (c) fits within the context of the linking party\'s site.\nIf you are among the organizations listed in paragraph 2 above and are interested in linking to our website, you must notify us by sending an e-mail to abc. Please include your name, your organization name, contact information (such as a phone number and/or e-mail address) as well as the URL of your site, a list of any URLs from which you intend to link to our Web site, and a list of the URL(s) on our site to which you would like to link. Allow 2-3 weeks for a response.\nApproved organizations may hyperlink to our Web site as follows:\n\t1.\tBy use of our corporate name; or\n\t2.\tBy use of the uniform resource locator (Web address) being linked to; or\n\t3.\tBy use of any other description of our Web site or material being linked to that makes sense within the context and format of content on the linking party\'s site.\nNo use of LUMS\'s logo or other artwork will be allowed for linking absent a trademark license agreement.\nIframes\nWithout prior approval and express written permission, you may not create frames around our Web pages or use other techniques that alter in any way the visual presentation or appearance of our Web site.\nReservation of Rights\nWe reserve the right at any time and in its sole discretion to request that you remove all links or any particular link to our Web site. You agree to immediately remove all links to our Web site upon such request. We also reserve the right to amend these terms and conditions and its linking policy at any time. By continuing to link to our Web site, you agree to be bound to and abide by these linking terms and conditions.\nRemoval of links from our website\nIf you find any link on our Web site or any linked web site objectionable for any reason, you may contact us about this. We will consider requests to remove links but will have no obligation to do so or to respond directly to you.\nWhilst we endeavour to ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we commit to ensuring that the website remains available or that the material on the website is kept up to date.\nContent Liability\nWe shall have no responsibility or liability for any content appearing on your Web site. You agree to indemnify and defend us against all claims arising out of or based upon your Website. No link(s) may appear on any page on your Web site or within any context containing content or materials that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.\nDisclaimer\nTo the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website (including, without limitation, any warranties implied by law in respect of satisfactory quality, fitness for purpose and/or the use of reasonable care and skill). Nothing in this disclaimer will:\n\t1.\tlimit or exclude our or your liability for death or personal injury resulting from negligence;\n\t2.\tlimit or exclude our or your liability for fraud or fraudulent misrepresentation;\n\t3.\tlimit any of our or your liabilities in any way that is not permitted under applicable law; or\n\t4.\texclude any of our or your liabilities that may not be excluded under applicable law.\nThe limitations and exclusions of liability set out in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer or in relation to the subject matter of this disclaimer, including liabilities arising in contract, in tort (including negligence) and for breach of statutory duty.\nTo the extent that the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.\nTerms\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.\nCredit & Contact Information\nThis Terms and conditions page was created at termsandconditionstemplate.com generator. If you have any queries regarding any of our terms, please contact us.\n")
        
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServiceNegativeMock(), registerUserService: RegisterUserServicePositiveMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        XCTAssertNotNil(outputHandler.showError)
        XCTAssertEqual(outputHandler.showError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.showError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.showError?.errorCode, 401)
    }
    
    func testDidTapRegisterUserPositive() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServiceNegativeMock(), registerUserService: RegisterUserServicePositiveMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.didTapRegisterButton()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertTrue(router.didNavigateToRegistrationCompleted)
    }
    
    func testDidTapRegisterUserNegative() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServiceNegativeMock(), registerUserService: RegisterUserServiceNegativeMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.didTapRegisterButton()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        XCTAssertNotNil(outputHandler.showError)
        XCTAssertEqual(outputHandler.showError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.showError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.showError?.errorCode, 401)
    }
    
    func testDidTapDeclineTermsAndCondition() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServiceNegativeMock(), registerUserService: RegisterUserServiceNegativeMock())
        
        let outputHandler = TermsAndConditionOutputHandler(ViewModel: viewModel)
        
        viewModel.didTapDeclinedTermsAndCondition()
        
        XCTAssertTrue(outputHandler.showConfirmRegistrationDeclineAlert)
    }
    
    func testConfirmDeclinedRegistration() {
        let viewModel = TermsAndConditionViewModel(with: router, model: getRegisterRequestMock(), termsAndConditionService: TermsAndConditionServiceNegativeMock(), registerUserService: RegisterUserServiceNegativeMock())
        
        viewModel.didConfirmedDeclinedRegistration()
        
        XCTAssertTrue(router.didNavigateToLogin)
    }
}

class TermsAndConditionOutputHandler {
    var nextButtonEnabled: Bool = false
    var nextButtonDisabled: Bool = false
    var showConfirmRegistrationDeclineAlert: Bool = false
    var updateTermsAndCondition: NSAttributedString?
    var showError: APIResponseError?
    var showActivityIndicator: Bool = false
    var hideActivityIndicator: Bool = false
    
    var viewModel: TermsAndConditionViewModelProtocol

    init(ViewModel: TermsAndConditionViewModelProtocol) {
        self.viewModel = ViewModel
        setupObserver()
    }
    
    func reset() {
        nextButtonEnabled = false
        nextButtonDisabled = false
        showActivityIndicator = false
        hideActivityIndicator = false
        showConfirmRegistrationDeclineAlert = false
        updateTermsAndCondition = nil
        showError = nil
    }
    
    private func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .showError(let error):
                self.showError = error
            case .showActivityIndicator(let show):
                if show {
                    self.showActivityIndicator = true
                } else {
                    self.hideActivityIndicator = true
                }
            case .nextButtonState(let enableState):
                if enableState {
                    self.nextButtonEnabled = true
                } else {
                    self.nextButtonDisabled = true
                }
            case .showConfirmRegistrationDeclineAlert:
                self.showConfirmRegistrationDeclineAlert = true
            case .updateTermsAndCondition(let content):
                self.updateTermsAndCondition = content
            }
        }
    }
}
