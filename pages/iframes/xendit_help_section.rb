class XenditHelpSection < SitePrism::Page
  element :input_search, 'input[type=search]'
  element :question, :xpath, "//a[text()='What is currently supported eWallet by Xendit?']"
  element :answer, 'div p span'
end
