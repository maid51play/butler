import React from 'react';
import { shallow } from 'enzyme';
import MaidEdit from '../maidEdit';
import MaidForm from '../maidForm';

describe('', () => {
  it('renders the maid edit form', () => {
    const wrapper = shallow(<MaidEdit token="" />);
    expect(wrapper.find(MaidForm).exists()).toBe(true);
  });
});
