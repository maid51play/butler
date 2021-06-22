import React from 'react';
import { shallow } from 'enzyme';
import BootstrapPagination from 'react-bootstrap/Pagination';
import Pagination from '../pagination';


describe('', () => {
  it('renders the pagination when 2 pages are present and the first page is selected', () => {
    const wrapper = shallow(<Pagination url="/foo" totalPages={2} pageNumber={1} />);

    expect(wrapper.find(BootstrapPagination).exists()).toBe(true);

    expect(wrapper.find(BootstrapPagination.Prev).exists()).toBe(false);
    expect(wrapper.find(BootstrapPagination.Next).exists()).toBe(true);

    expect(wrapper.find(BootstrapPagination.Item)).toHaveLength(4);

    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('children')).toBe('start');
    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('children')).toBe(1);
    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('active')).toBe(true);

    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('children')).toBe(2);
    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('children')).toBe('end');
    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('active')).toBe(false);
  });

  it('renders the pagination when 2 pages are present and the second page is selected', () => {
    const wrapper = shallow(<Pagination url="/foo" totalPages={2} pageNumber={2} />);

    expect(wrapper.find(BootstrapPagination).exists()).toBe(true);

    expect(wrapper.find(BootstrapPagination.Prev).exists()).toBe(true);
    expect(wrapper.find(BootstrapPagination.Next).exists()).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item)).toHaveLength(4);

    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('children')).toBe('start');
    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('children')).toBe(1);
    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('children')).toBe(2);
    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('active')).toBe(true);

    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('children')).toBe('end');
    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('active')).toBe(false);
  });

  it('renders the pagination when 10 pages are present', () => {
    const wrapper = shallow(<Pagination url="/foo" totalPages={10} pageNumber={5} />);

    expect(wrapper.find(BootstrapPagination).exists()).toBe(true);

    expect(wrapper.find(BootstrapPagination.Prev).exists()).toBe(true);
    expect(wrapper.find(BootstrapPagination.Next).exists()).toBe(true);

    expect(wrapper.find(BootstrapPagination.Item)).toHaveLength(7);

    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('children')).toBe('start');
    expect(wrapper.find(BootstrapPagination.Item).at(0).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('children')).toBe(3);
    expect(wrapper.find(BootstrapPagination.Item).at(1).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('children')).toBe(4);
    expect(wrapper.find(BootstrapPagination.Item).at(2).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('children')).toBe(5);
    expect(wrapper.find(BootstrapPagination.Item).at(3).prop('active')).toBe(true);

    expect(wrapper.find(BootstrapPagination.Item).at(4).prop('children')).toBe(6);
    expect(wrapper.find(BootstrapPagination.Item).at(4).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(5).prop('children')).toBe(7);
    expect(wrapper.find(BootstrapPagination.Item).at(5).prop('active')).toBe(false);

    expect(wrapper.find(BootstrapPagination.Item).at(6).prop('children')).toBe('end');
    expect(wrapper.find(BootstrapPagination.Item).at(6).prop('active')).toBe(false);
  });

  it('does not render the pagination when only 1 page is present', () => {
    const wrapper = shallow(<Pagination url="/foo" totalPages={1} pageNumber={1} />);

    expect(wrapper.find(BootstrapPagination).exists()).toBe(false);
  });
});
