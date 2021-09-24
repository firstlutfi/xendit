class XenditDashboardPage < SitePrism::Page
  set_url 'home'

  element :txt_title, '.mt-5.font-weight-600.text-center'
  element :btn_callbacks_menu, 'a#lhs-callbacks'
  element :btn_settings_menu, 'a#lhs-settings'
  iframe :iframe_help_button, XenditHelpButton, '#launcher'
  iframe :iframe_help_section, XenditHelpSection, '#webWidget'
end
