import React from 'react';
import { shallow } from 'enzyme';
import MaidForm from '../maidForm';

describe('', () => {
  it('renders the maid form', () => {
    const wrapper = shallow(<MaidForm token="" action="post" method="" />);
    expect(wrapper.find('form').exists()).toBe(true);
  });
});
