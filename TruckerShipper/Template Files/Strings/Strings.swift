//
//  Strings.swift
//  Gym Buzz
//
//  Created by Usman Bin Rehan on 8/21/18.
//  Copyright © 2018 Usman Bin Rehan. All rights reserved.
//

import Foundation

enum Strings: String{
    
    //SingleMethod For the Usage of Localization.
    var text: String { return NSLocalizedString( self.rawValue, comment: "") }
    
    //MARK:- Notifies
    case ALERT = "Alert"
    case ERROR = "Error"
    case UNKNOWN_ERROR = "Unknown error"
    case YES = "Yes"
    case NO = "No"
    case OK = "Ok"
    case CANCEL = "Cancel"
    case CONTINUE = "Continue"
    case CONFIRM = "Confirm"
    case LATER = "Later"
    case SUCCESS = "Success"
    case CONFIRMATION = "Confirmation"
    case PIN_SENT_EMAIL = "A verification PIN has been sent to your provided email address."
    
    //MARK:- Validation
    case EMPTY_LOGIN_FIELDS = "Please provide your valid email address or mobile number to login."
    case PROFILE_IMAGE_REQUIRED = "Please upload your profile picture."
    case INVALID_NAME = "Name should contain atleast 3 characters."
    case INVALID_F_NAME = "First name should contain atleast 3 characters."
    case INVALID_L_NAME = "Last name should contain atleast 3 characters."
    case INVALID_GENDER = "Please select your gender."
    case INVALID_DATE_OF_BIRTH = "Please select your date of birth."
    case INVALID_EMAIL = "Please provide a valid Email Address."
    case INVALID_PHONE = "Please provide a valid Phone Number."
    case INVALID_OTP = "Please provide a valid OTP Code."
    case INVALID_COUNTRY = "Please select your country."
    case INVALID_CITY = "Please enter your city."
    case INVALID_ZIP_CODE = "Please enter your zip code."
    case EMPTY_PWD = "Please provide password."
    case EMPTY_CONFIRM_PWD = "Please confirm your password."
    case INVALID_PWD_LENGTH = "Password should contain minimum of 6 characters."
    case INVALID_PWD = "Password should contain minimum of 8 characters with atleast 1 uppercase, 1 lowercase and 1 digit."
    case PWD_ATLEAST_SIX_CH = "At least 6 characters."
    case PWD_DONT_MATCH = "New password and confirm password does not match."
    case ALL_FIELD_REQ = "All Fields are required!"
    case INVALID_PIN = "Please provide complete PIN."
    case PWD_CHANGED = "You have successfully updated your password."
    case URL_NOT_VALID = "Invalid URL"
    case LOGIN = "Login"
    case LOGOUT = "Logout"
    case ASK_LOGOUT = "Are you sure you want to logout?"
    case ASK_GUEST_LOGOUT = "Please login to continue."
    
    case RESPONSE_ERROR = "Invalid response for route:"
    case ERROR_GENERIC_MESSAGE = "Unable to connect server\n Please check your internet connection and try again later."
    case TOKEN_EXPIRED = "Invalid authentication token supplied."
    case PASSWORD_UPDATED = "Password updated successfully."
    case MESSAGE_DELIVERED = "Message delivered"
    case CONTACT_US_SUBMITTED = "Our team will respond you shortly."
    
    case TERMS_AND_POLICIES = "By signing up, you're agree to our Terms of use and Privacy Policy"
    case TERMS_OF_SERVICES = "Terms of use"
    case PRIVACY_POLICY = "Privacy Policy"
    case SELECT_SHIPPER = "Please select shipper type."
    
}
