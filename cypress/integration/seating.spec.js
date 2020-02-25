// <reference types="Cypress" />

context('Seating parties without a waitlist reservation', () => {
    let tableA1;
    let tableA2;
    let party1;
    let party2;
    let party3;
    let party4;
  
    beforeEach(() => {
      tableA1 = { table_number: 'A1', max_capacity: '8' };
      tableA2 = { table_number: 'A2', max_capacity: '8' };
      party1 = {};
      party2 = {};
      party3 = {};
      party4 = {};
  
      cy.factorydb('table', tableA1)
        .then((result) => { tableA1.id = result.body.id; })
        .then(() => cy.factorydb('party', { table_id: tableA1.id }))
        .then((result) => {
          party1 = { table_id: tableA1.id, id: result.body.id };
        })
        .then(() => {
          tableA1.parties = [party1.id];
        });
  
      cy.factorydb('maid', {
        name: 'Kotori',
        status: 'present',
        checked_in_at: new Date(),
      });
  
      cy.login();
  
      cy.visit('localhost:4001/');
    });
  
    it('seating happy path', () => {
  
      cy.contains('Tables').click();
  
      cy.contains('A1').parent().contains('Book').click();

      cy.get('#reservation_size').type('1').should('have.value', '1');

      cy.contains('Shinkansen').click();

      cy.contains('Staff').click();

      cy.get('#reservation_notes').type('Hayao Miyazaki himself.').should('have.value', 'Hayao Miyazaki himself.');
    
      cy.contains('Kotori').click();
  
      // mocking the barcode input
      cy.window().then((win) => {
        // eslint-disable-next-line no-param-reassign, prefer-destructuring
        win.document.getElementById('reservation_party_id').value = tableA1.parties[0];
      });
  
      cy.contains('Submit').click();
  
      cy.contains('Reservation created successfully.').should('be.visible');
  
      cy.contains('Tables').click();
  
      cy.contains('td', 'Kotori').parent().children().first()
        .next()
        .should('have.text', '8')
        .next()
        .should('have.text', '7')
        .next()
        .next()
        .should('have.text', '1')
        .next()
        .should('have.text', 'a few seconds');
  
      cy.contains('Clear Party').click();
  
      // mocking the barcode input
      cy.window().then((win) => {
        // eslint-disable-next-line no-param-reassign, prefer-destructuring
        win.document.getElementById('reservation_party_id').value = tableA1.parties[0];
      });
  
      cy.contains('Submit').click();
  
      cy.contains('Reservation cleared successfully.').should('be.visible');
    });
  });
  