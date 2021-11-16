import React from 'react';
import { render, screen } from '@testing-library/react';
import { within } from '@testing-library/dom';
import '@testing-library/jest-dom';
import WaitlistComponent from '../waitlist';

const nicoReservation = {
  id: 1,
  name: 'nico',
  size: 2,
  seat_alone: false,
  shinkansen: false,
  staff: false,
  time_waitlisted: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
  notes: 'nico notes',
};
const kotoriReservation = {
  id: 2,
  name: 'kotori',
  size: 4,
  seat_alone: false,
  shinkansen: false,
  staff: false,
  time_waitlisted: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
  notes: '',
};
const rinReservation = {
  id: 3,
  name: 'rin',
  size: 1,
  seat_alone: true,
  shinkansen: false,
  staff: false,
  time_waitlisted: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
  notes: 'rin notes',
};

const waitlist = {
  total_pages: 1,
  page_number: 1,
  entries: [nicoReservation, kotoriReservation, rinReservation],
};

let dateNowSpy;
// eslint-disable-next-line no-undef
beforeAll(() => {
  // Lock Time

  // eslint-disable-next-line no-undef
  dateNowSpy = jest.spyOn(Date, 'now').mockImplementation(() => 1636507241759);
});
// eslint-disable-next-line no-undef
afterAll(() => {
  // Unlock Time
  dateNowSpy.mockRestore();
});

describe('#waitlist', () => {
  it('renders without crashing', () => {
    render(<WaitlistComponent waitlist={waitlist} />);

    const table = screen.getByRole('table');
    const [headers, ...rows] = within(table).getAllByRole('rowgroup');
    const [...columnNames] = within(headers).getAllByRole('columnheader');
    const [...nicoValues] = within(rows[0]).getAllByRole('cell');

    expect(columnNames[0].textContent).toEqual('Name');
    expect(columnNames[1].textContent).toEqual('Size');
    expect(columnNames[2].textContent).toEqual('Seat alone?');
    expect(columnNames[3].textContent).toEqual('Time waitlisted');
    expect(columnNames[4].textContent).toEqual('Notes');

    expect(nicoValues[0].textContent).toEqual('nico');
    expect(nicoValues[1].textContent).toEqual('2');
    expect(nicoValues[2].textContent).toEqual('');
    expect(nicoValues[3].textContent).toEqual('12:54 am');
    expect(nicoValues[4].textContent).toEqual('nico notes');

    expect(nicoValues[12].textContent).toEqual('rin');
    expect(nicoValues[13].textContent).toEqual('1');
    expect(nicoValues[14].textContent).toEqual('💖');
    expect(nicoValues[15].textContent).toEqual('12:54 am');
    expect(nicoValues[16].textContent).toEqual('rin notes');
  });
});
