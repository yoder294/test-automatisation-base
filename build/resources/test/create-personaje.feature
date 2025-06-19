Feature: Crear personaje y devolver id

  Scenario: Crear personaje condicionalmente y devolver id
    Given url 'http://localhost:8080/api/characters'
    When method get
    Then status 200
    * def personaje = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    * def nuevoPersonaje = { name: 'Hulk 12', alterego: 'Bruce Banner', description: 'Strongest Avenger', powers: ['Strength', 'Regeneration'] }
    * def existe = karate.filter(response, function(x){ return x.name == personaje.name })
    * def crear = existe.length == 0 ? personaje : nuevoPersonaje
    Given url 'http://localhost:8080/api/characters'
    And request crear
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * def personajeId = response.id
    * def personajeName = response.name
