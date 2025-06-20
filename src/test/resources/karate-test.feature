Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/espantoj'

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  @id:1 @GetAllCharacters
  Scenario: T-Api-CA1- Get All Characters
    Given path '/api/characters'
    When method GET
    Then status 200
    * print response

  @id:2 @GetCharacterByIdSuccess
  Scenario Outline: T-Api-CA2- Get Character by id <id>, successfully
    Given path '/api/characters/<id>'
    When method GET
    Then status <statusCode>
    Examples:
      | id | statusCode |
      | 1  | 200        |

  @id:3 @GetCharacterByIdFailed
  Scenario Outline: T-Api-CA3- Get Character by id <id>, failed
    Given path '/api/characters/<id>'
    When method GET
    Then status <statusCode>
    Examples:
      | id  | statusCode |
      | 100 | 404        |

  @id:4 @CreateCharacter
  Scenario Outline: T-Api-CA4- Create Characters <name>, successfully
    * def body = read('classpath:character-schema.json')
    * def uuidGenerate = java.util.UUID.randomUUID().toString()
    * set body.name = "<name>" + " " + uuidGenerate
    * set body.alterego = "<alterego>"
    * set body.description = "<description>"
    * set body.powers = <powers>
    * print body
    Given path '/api/characters'
    And request body
    When method POST
    Then status 201
    * print response
    Examples:
      | read('classpath:characters-create-schema.json') |

  @id:5 @CreateCharacterDuplicate
  Scenario: T-Api-CA5- Create Characte Duplicate
    And request { "name": "Iron Man", "alterego": "Otro", "description": "Otro", "powers": ["Armor"]   }
    Given path '/api/characters'
    When method POST
    Then status 400
    * print response
    * match response.error contains 'exists'
    * match response.error == '#string'

  @id:6 @CreateCharacterFieldsRequired
  Scenario: T-Api-CA6- Create Character Field Required
    And request { "name": "", "alterego": "", "description": "", "powers": [] }
    Given path '/api/characters'
    When method POST
    Then status 400
    * print response
    * match response.name contains 'Name is required'
    * match response.name == '#string'


  @id:7 @UpdateCharacterById
  Scenario Outline: T-Api-CA7- Update Character by id <id>
    And request { "name": "<name>", "alterego": "Update Alterego", "description": "Description Update", "powers": ["power1", "power2"] }
    Given path '/api/characters/<id>'
    When method PUT
    Then status 200
    * print response
    Examples:
      | id | name               |
      | 4  | Super Heroe Update |

  @id:8 @UpdateCharacterNotExists
  Scenario Outline: T-Api-CA7- Update Character not exits, <id>
    And request { "name": "<name>", "alterego": "Update Alterego", "description": "Description Update", "powers": ["power1", "power2"] }
    Given path '/api/characters/<id>'
    When method PUT
    Then status 404
    * match response.error contains 'not found'
    Examples:
      | id       | name               |
      | 71024569 | Super Heroe Update |

  @id:9 @DeleteCharacterSuccess
  Scenario: T-Api-CA9- Delete Character Successfully
    # First Create Charter
    * def body = { "name": "Character Delete", "alterego": "Alterego Delete", "description": "Description Delete", "powers": ["power1", "power2"] }
    Given path '/api/characters'
    And request body
    When method POST
    Then status 201
    * print response
    * def createId = response.id

    # Second Delete Charter
    Given path '/api/characters/', createId
    When method DELETE
    Then status 204
    * print 'Character Create and Delete:', createId


  @id:10 @DeleteCharacterNotExists
  Scenario Outline: T-Api-CA7- Delete Character not exits, <id>
    Given path '/api/characters/<id>'
    When method DELETE
    Then status 404
    * match response.error contains 'not found'
    Examples:
      | id       |
      | 71024569 |