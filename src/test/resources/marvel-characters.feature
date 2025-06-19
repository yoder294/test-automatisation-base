Feature: Pruebas API de personajes de Marvel

  Background:
    * def result = callonce read('classpath:create-personaje.feature')
    * def personajeId = result.personajeId
    * def personajeName = result.personajeName
    * url baseUrl = 'http://localhost:8080/api/characters'
    * configure ssl = true
    
   Scenario: Validar respuesta según si la lista está vacía o no
    Given url baseUrl
    When method get
    Then status 200
    * def isEmpty = response.length == 0
    * if (isEmpty) karate.match(response, [])
    * if (!isEmpty) karate.match(response[0], { id: '#number', name: '#string' })

  Scenario: Crear personaje con nombre duplicado
    Given url baseUrl
    And request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Obtener personaje por ID (exitoso)
    * def id = personajeId
    * def nombre = personajeName
    Given url baseUrl + '/' + id
    When method get
    Then status 200
    And match response.id == id
    And match response.name == nombre

  Scenario: Obtener personaje por ID (no existe)
    Given url baseUrl + '/999'
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje con campos requeridos vacíos
    Given url baseUrl
    And request { name: '', alterego: '', description: '', powers: [] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  Scenario: Actualizar personaje exitosamente
  * def id = karate.get('personajeId')
    Given url baseUrl + '/' + id 
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Actualizar personaje (no existe)
    Given url baseUrl + '/999'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje exitosamente
    Given url baseUrl + '/' + personajeId
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given url baseUrl + '/999'
    When method delete
    Then status 404
    And match response.error == 'Character not found'

