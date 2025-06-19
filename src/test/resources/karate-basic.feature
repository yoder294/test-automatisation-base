Feature: Test positivo simple

  Scenario: Verificar que el endpoint responde 200
    Given url 'http://httpbin.org/status/200'
    When method get
    Then status 200
