import React from 'react';
import { shallow } from 'enzyme';
import MaidNew from '../maidNew';
import MaidForm from '../maidForm';

describe('', () => {
  it('renders the maid new form', () => {
    const wrapper = shallow(<MaidNew token="" />);
    expect(wrapper.find(MaidForm).exists()).toBe(true);
  });
});
