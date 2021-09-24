class XenditSettingsPage < SitePrism::Page
  set_url 'settings/developers#api-keys'

  element :btn_create_new_secret_key, :xpath, "//button[text()='Generate secret key']"
  element :input_api_key_name, 'input[name=apiKeyName]'
  elements :btn_permission_none, '.button-selector-left'
  elements :btn_permission_read, '.button-selector-middle'
  elements :btn_permission_write, '.button-selector-right'
  element :btn_generate_key, '.btn.btn-primary.btn-md.ml-2'
  element :input_password, '.input-text-content input[type=password]'
  element :btn_confirm_password, '.password-modal-footer .btn-primary'
  element :txt_secret_key, '.secret-api-key-success'
  element :btn_close_modal, :xpath, "//button[text()='Close']"
  element :btn_close_modal_edit, :xpath, "//button[text()='Okay']"
  elements :btn_edit_secret_key, :xpath, "//img[@src='/images/icons/icon_edit_grey.svg']"
  elements :btn_delete_secret_key, :xpath, "//img[@src='/images/icons/icon_delete.svg']"
  element :btn_confirm_delete, '.btn.btn-destructive.btn-md'
  element :btn_apply_changes, :xpath, "//button[text()='Apply changes']"
  element :img_icon_success, :xpath, "//img[@src='/images/icons/confirmation-modal/icon-success-new.svg']"
  element :txt_alert, '.alert.alert-danger'
end
