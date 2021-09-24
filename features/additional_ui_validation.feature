Feature: Additional UI Validation

  Background:
    Given user login using 'xendit_default_user'

  # This scenario is expected to fail because there is also ShopeePay in the list of supported eWallets
  Scenario: Check for available eWallets
    When user search for 'eWallets' in the help section
    Then validate supported eWallets are 'OVO, DANA and LinkAja'

