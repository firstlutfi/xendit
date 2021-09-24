class XenditCallbacksPage < SitePrism::Page
  set_url 'callbacks'

  element :input_search, 'input[type=text]'
  elements :list_transactions, 'table.table tbody tr'
  element :txt_transaction_status, '.pill-container'
  element :txt_product_type, :xpath, "//span[text()='Product Type']/following-sibling::span"
  element :txt_transaction_date, :xpath, "//span[text()='Date']/following-sibling::span/div//p[1]"
end
