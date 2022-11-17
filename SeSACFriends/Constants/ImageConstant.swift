//
//  ImageConstant.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

/// 이미지, 이미지 사이즈(폰트)
typealias ImageInfo = (image: UIImage, imageSize: CGFloat)

@frozen enum Images {
    
    // onboarding
    static let logoText = UIImage(named: "txt")!
    static let splashLogo = UIImage(named: "splash_logo")!
    static let onboardingImage1 = UIImage(named: "onboarding_img1")!
    static let onboardingImage2 = UIImage(named: "onboarding_img2")!
    static let onboardingImage3 = UIImage(named: "onboarding_img3")!
    
    // tabbarImage
    static let tabbarHome = UIImage(named: "Property 1=home, Property 2=act")!
    static let tabbarHome_inActive = UIImage(named: "Property 1=home, Property 2=inact")!
    static let tabbarShop = UIImage(named: "Property 1=shop, Property 2=act")!
    static let tabbarShop_inAcive = UIImage(named: "Property 1=shop, Property 2=inact")!
    static let tabbarFriends = UIImage(named: "Property 1=friends, Property 2=act")!
    static let tabbarFriends_inAcive = UIImage(named: "Property 1=friends, Property 2=inact")!
    static let tabbarProfile = UIImage(named: "Property 1=my, Property 2=act")!
    static let tabbarProfile_inAcive = UIImage(named: "Property 1=my, Property 2=inact")!
    
    // etc
    static let mapMarker: ImageInfo = (UIImage(named: "map_marker")!, 48)
    static let bagde: ImageInfo = (UIImage(named: "bagde")!, 16)
    
    // Button
    // send Button
    static let sendActive = UIImage(named: "Property 1=send, Property 2=act")!
    static let sendInactive = UIImage(named: "Property 1=send, Property 2=inact")!
    
    // icons
    static let antenna: ImageInfo = (UIImage(named: "antenna")!, 40)
    static let arrow: ImageInfo = (UIImage(named: "arrow")!, 24)
    static let bell: ImageInfo = (UIImage(named: "bell")!, 24)
    static let cancelMatch: ImageInfo = (UIImage(named: "cancel_match")!, 24)
    static let check: ImageInfo = (UIImage(named: "check")!, 16)
    static let closeBig: ImageInfo = (UIImage(named: "close_big")!, 24)
    static let closeSmall: ImageInfo = (UIImage(named: "close_small")!, 16)
    static let faq: ImageInfo = (UIImage(named: "faq")!, 24)
    static let filterControll: ImageInfo = (UIImage(named: "filter_control")!, 24)
    static let friendsPlus: ImageInfo = (UIImage(named: "friends_plus")!, 24)
    static let logout: ImageInfo = (UIImage(named: "logout")!, 24)
    static let man: ImageInfo = (UIImage(named: "man")!, 64)
    static let message: ImageInfo = (UIImage(named: "message")!, 24)
    static let moreArrow: ImageInfo = (UIImage(named: "more_arrow")!, 16)
    static let upmoreArrow: ImageInfo = (UIImage(named: "upCross")!, 16)
    static let more: ImageInfo = (UIImage(named: "more")!, 24)
    static let notice: ImageInfo = (UIImage(named: "notice")!, 24)
    static let permit: ImageInfo = (UIImage(named: "permit")!, 24)
    static let place: ImageInfo = (UIImage(named: "place")!, 24)
    static let plus: ImageInfo = (UIImage(named: "plus")!, 24)
    static let qna: ImageInfo = (UIImage(named: "qna")!, 24)
    static let search: ImageInfo = (UIImage(named: "search")!, 24)
    static let searchlarge: ImageInfo = (UIImage(named: "search_large")!, 40)
    static let seed: ImageInfo = (UIImage(named: "seed")!, 64)
    static let settingAlarm: ImageInfo = (UIImage(named: "setting_alarm")!, 24)
    static let siren: ImageInfo = (UIImage(named: "siren")!, 40)
    static let woman: ImageInfo = (UIImage(named: "woman")!, 64)
    static let write: ImageInfo = (UIImage(named: "write")!, 24)
    
    // sesac Face
    static let sesacFace1: ImageInfo = (UIImage(named: "sesac_face_1")!, 160)
    static let sesacFace2: ImageInfo = (UIImage(named: "sesac_face_2")!, 160)
    static let sesacFace3: ImageInfo = (UIImage(named: "sesac_face_3")!, 160)
    static let sesacFace4: ImageInfo = (UIImage(named: "sesac_face_4")!, 160)
    static let sesacFace5: ImageInfo = (UIImage(named: "sesac_face_5")!, 160)
    
    // background
    static let background1 = UIImage(named: "sesac_background_1")!
    static let background2 = UIImage(named: "sesac_background_2")!
    static let background3 = UIImage(named: "sesac_background_3")!
    static let background4 = UIImage(named: "sesac_background_4")!
    static let background5 = UIImage(named: "sesac_background_5")!
    static let background6 = UIImage(named: "sesac_background_6")!
    static let background7 = UIImage(named: "sesac_background_7")!
    static let background8 = UIImage(named: "sesac_background_8")!
    static let background9 = UIImage(named: "sesac_background_9")!
}
