Feature: Create Virtual Account

  Background:
    Given user login using 'xendit_default_user'

  Scenario: C2,C12,C6,C8,C9,C10,C11,C12,C13,C16,C18,C19-User should be able to create, edit, and delete virtual account
    When user generate new secret key using 'secret_key_all_read'
    Then secret key should be successfully generated
    And user update secret key using 'secret_key_update'
    Then secret key should be successfully updated
    When user send 'POST' request to 'create_virtual_account' using 'virtual_account_default'
    Then API response should return 200
    And user validate callback response
    Then user delete the newly created secret key

  Scenario: C1-User should NOT be able to create secret key with all None permission
    When user generate new secret key using 'secret_key_all_none'
    Then secret key should not be created

  Scenario Outline: <case_id>-User should NOT be able to create virtual account with invalid values in JSON body
    When user generate new secret key using 'secret_key_all_write'
    Then secret key should be successfully generated
    When user send 'POST' request to 'create_virtual_account' using '<virtual_account_detail>'
    Then API response should return 400
    Then user delete the newly created secret key
  Examples:
    | case_id | virtual_account_detail            |
    | C3,C15  | virtual_account_invalid_bank_code |
    | C5,C17  | virtual_account_name_non_alphabet |

