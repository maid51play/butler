import React from 'react';
import { shallow } from 'enzyme';
import WaitlistEditComponent from '../waitlistEdit';
import WaitlistForm from '../waitlistForm';

const reservation = {
  id: 1,
  name: 'nico',
  size: 2,
  seat_alone: false,
  shinkansen: false,
  staff: false,
  time_waitlisted: 'Tue Nov 09 2021 16:54:47 GMT-0800 (Pacific Standard Time)',
  notes: 'nico notes',
};

describe('#waitlistEdit', () => {
  it('renders the edit form', () => {
    const wrapper = shallow(<WaitlistEditComponent token="token" reservation={reservation} />);

    expect(wrapper.find(WaitlistForm).exists()).toBe(true);
    expect(wrapper.find(WaitlistForm).props().token).toEqual('token');
    expect(wrapper.find(WaitlistForm).props().reservation).toEqual(reservation);
    expect(wrapper.find(WaitlistForm).props().action).toEqual('/waitlist/1');
    expect(wrapper.find(WaitlistForm).props().method).toEqual('post');
  });
});
