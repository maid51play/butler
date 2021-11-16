import React from 'react';
import { shallow } from 'enzyme';
import WaitlistNewComponent from '../waitlistNew';
import WaitlistForm from '../waitlistForm';

describe('#waitlistNew', () => {
  it('renders the new form', () => {
    const wrapper = shallow(<WaitlistNewComponent token="token" />);

    expect(wrapper.find(WaitlistForm).exists()).toBe(true);
    expect(wrapper.find(WaitlistForm).props().token).toEqual('token');
    expect(wrapper.find(WaitlistForm).props().reservation).toEqual({});
    expect(wrapper.find(WaitlistForm).props().action).toEqual('/waitlist');
    expect(wrapper.find(WaitlistForm).props().method).toEqual('post');
  });
});
