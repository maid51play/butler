import React from 'react';
import moment from 'moment';
import { shallow } from 'enzyme';
import Maid from '../maid';

describe('', () => {
  const maids = [
    { id: 1, name: 'Hanayo', status: 'not-present' },
    { id: 2, name: 'Rin', status: 'not-present' },
    { id: 3, name: 'Maki', status: 'not-present' },
  ];
  it('renders the maid list', () => {
    const wrapper = shallow(<Maid maids={maids} token="" />);
    expect(wrapper.find('table').exists()).toBe(true);
    expect(wrapper.find('tr')).toHaveLength(4);
  });

  it('renders a check out button and shows the time checked in when a maid is present', () => {
    const wrapper = shallow(<Maid
      maids={[...maids,
        {
          id: 4, name: 'Nico', status: 'present', checked_in_at: moment().subtract(1, 'h').format(),
        },
      ]}
      token=""
    />);

    expect(wrapper.find('tr').at(1).find('td').at(1)
      .text()).toBe('');
    expect(wrapper.find('tr').at(1).find('td').at(2)
      .text()).toBe('Check In');


    expect(wrapper.find('tr').last().find('td').at(1)
      .text()).toBe('1:00');
    expect(wrapper.find('tr').last().find('td').at(2)
      .text()).toBe('Check Out');
  });
});
