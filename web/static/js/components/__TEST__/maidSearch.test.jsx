import React from 'react';
import { shallow } from 'enzyme';
import MaidSearch from '../maidSearch';

describe('', () => {
  it('renders the maid search', () => {
    const wrapper = shallow(<MaidSearch />);
    expect(wrapper.find('form').exists()).toBe(true);
    expect(wrapper.find('#maidSearchInput').props().value).toBe('');
    expect(wrapper.find('.search-clear-button').exists()).toBe(false);
  });

  it('renders the maid search with search populated when a search is present', () => {
    const wrapper = shallow(<MaidSearch search="Mayushii" />);
    expect(wrapper.find('form').exists()).toBe(true);
    expect(wrapper.find('#maidSearchInput').props().value).toBe('Mayushii');
    expect(wrapper.find('.search-clear-button').exists()).toBe(true);
  });
});
